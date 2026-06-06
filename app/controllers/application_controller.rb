class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :authenticate_user!
  around_action :switch_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def switch_locale(&action)
    locale = session[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :sip_number, :clinic_name, :clinic_address, :clinic_phone])
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
