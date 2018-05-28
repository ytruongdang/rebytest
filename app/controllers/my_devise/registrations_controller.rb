class MyDevise::RegistrationsController < Devise::RegistrationsController
  protected
  def after_update_path_for current_user
    user_path
  end
end
