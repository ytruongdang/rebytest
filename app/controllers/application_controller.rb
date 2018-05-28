class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t "flash.access_denied"
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.not_found"
    redirect_to root_path
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :email,
      :password, :password_confirmation, :phone, :address]
    devise_parameter_sanitizer.permit :account_update, keys: [:name, :email,
      :password, :password_confirmation, :phone, :address, :current_password]
  end

  def after_sign_in_path_for current_user
    if current_user.is_admin?
      admin_users_path
    else
      root_path
    end
  end
end
