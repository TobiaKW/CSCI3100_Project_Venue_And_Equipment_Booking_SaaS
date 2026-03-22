# frozen_string_literal: true

require "json"
require "net/http"

# Custom Action Mailer delivery via SendGrid Web API (HTTPS).
# Use when SMTP to smtp.sendgrid.net fails with Net::OpenTimeout (common on some hosts).
# Set USE_SENDGRID_HTTP_API=true and SENDGRID_API_KEY (or reuse SMTP_PASSWORD).
class SendgridHttpDelivery
  attr_accessor :settings

  def initialize(values = {})
    h = values.respond_to?(:symbolize_keys) ? values.symbolize_keys : values
    self.settings = { api_key: nil, open_timeout: 30, read_timeout: 30 }.merge(h)
  end

  def deliver!(mail)
    api_key = settings[:api_key].presence
    raise ArgumentError, "SendgridHttpDelivery: set api_key (SENDGRID_API_KEY or SMTP_PASSWORD)" if api_key.blank?

    uri = URI("https://api.sendgrid.com/v3/mail/send")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = settings[:open_timeout] if settings[:open_timeout]
    http.read_timeout = settings[:read_timeout] if settings[:read_timeout]

    req = Net::HTTP::Post.new(uri)
    req["Authorization"] = "Bearer #{api_key}"
    req["Content-Type"] = "application/json"
    req.body = build_payload(mail).to_json

    response = http.request(req)
    return if response.code.to_i == 202

    body_preview = response.body.to_s
    body_preview = body_preview[0, 500] if body_preview.length > 500
    raise "SendGrid API #{response.code}: #{body_preview}"
  end

  private

  def build_payload(mail)
    to = addresses_to_sg(mail.to_addrs)
    raise ArgumentError, "SendgridHttpDelivery: message has no recipients" if to.empty?

    personalization = { "to" => to }
    cc = addresses_to_sg(mail.cc_addrs)
    personalization["cc"] = cc if cc.any?
    bcc = addresses_to_sg(mail.bcc_addrs)
    personalization["bcc"] = bcc if bcc.any?

    from = first_from(mail)
    content = build_content(mail)

    payload = {
      "personalizations" => [ personalization ],
      "from" => from,
      "subject" => mail.subject.to_s,
      "content" => content
    }

    if mail.reply_to.present?
      rt = Mail::Address.new(Array(mail.reply_to).first.to_s)
      payload["reply_to"] = { "email" => rt.address }
      payload["reply_to"]["name"] = rt.display_name if rt.display_name.present?
    end

    payload
  end

  # Mail sometimes returns Mail::Address objects, sometimes plain strings.
  def parse_address(addr)
    case addr
    when Mail::Address
      addr
    else
      Mail::Address.new(addr.to_s)
    end
  end

  def addresses_to_sg(mail_addresses)
    Array(mail_addresses).map do |a|
      parsed = parse_address(a)
      h = { "email" => parsed.address }
      h["name"] = parsed.display_name if parsed.display_name.present?
      h
    end
  end

  def first_from(mail)
    raw = mail.from_addrs&.first || Array(mail.from).first
    raise ArgumentError, "SendgridHttpDelivery: message has no From" unless raw

    parsed = parse_address(raw)
    h = { "email" => parsed.address }
    h["name"] = parsed.display_name if parsed.display_name.present?
    h
  end

  def build_content(mail)
    parts = []
    if mail.multipart?
      parts << { "type" => "text/plain", "value" => mail.text_part.decoded } if mail.text_part
      parts << { "type" => "text/html", "value" => mail.html_part.decoded } if mail.html_part
    else
      body = mail.body.decoded.to_s
      if mail.content_type.to_s.include?("html")
        parts << { "type" => "text/html", "value" => body }
      else
        parts << { "type" => "text/plain", "value" => body }
      end
    end
    parts << { "type" => "text/plain", "value" => " " } if parts.empty?
    parts
  end
end
