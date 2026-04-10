require 'rails_helper'
require 'timecop'
require_relative 'shared_context.rb'

RSpec.describe Booking, type: :model do
  include_context "database"
  let (:freeze_date) { Time.zone.local(2026, 4, 10, 0, 0, 0) }
  let (:booking) do
    Booking.new({ 
      :user => users[:alice],
      :department => departments[:maths],
      :resource => resources[:room]
    })
  end
  context "correct usage" do
    it "validates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = freeze_date + 7.day + 10.hour
        booking.end_time = freeze_date + 7.day + 11.hour
        expect(booking.valid?).to be(true)
      end
    end
  end

  context "missing start time or end time" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = nil
        booking.end_time = freeze_date + 7.day + 11.hour
        expect(booking.valid?).to be(false)
        
        booking.start_time =  freeze_date + 7.day + 10.hour
        booking.end_time = nil
        expect(booking.valid?).to be(false)
      end
    end
  end

  context "end time before start time" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = freeze_date + 7.day + 11.hour
        booking.end_time = freeze_date + 7.day + 10.hour
        expect(booking.valid?).to be(false)
      end
    end
  end
  
  context "lasts less than an hour" do
    it "invalidates" do
      Timecop.freeze(freeze_date) do
        booking.start_time = freeze_date + 7.day + 10.hour
        booking.end_time = freeze_date + 7.day + 10.hour + 30.minute
        expect(booking.valid?).to be(false)
      end
    end
  end

  context "overlapping bookings for resource" do
    pending()
  end

  context "less than seven days in advance" do
    pending()
  end

  context "overnight booking of equipment" do
    pending()
  end

  context "overnight booking of venue" do
    pending()
  end
end
