class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
  rescue ActiveRecord::RecordNotUnique
    self.resource = build_resource(sign_up_params)
    resource.errors.add(:base, "Username already exists")
    clean_up_passwords(resource)
    set_minimum_password_length
    render :new, status: :unprocessable_entity
  end

  def update
    super
  rescue ActiveRecord::RecordNotUnique
    self.resource = resource_class.to_adapter.get!(send("current_#{resource_name}").to_key)
    resource.assign_attributes(account_update_params)
    resource.errors.add(:base, "Username already exists")
    clean_up_passwords(resource)
    render :edit, status: :unprocessable_entity
  end
end
