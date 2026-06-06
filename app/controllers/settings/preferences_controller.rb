class Settings::PreferencesController < ApplicationController
  def show
  end

  def update
    if params[:locale].present?
      session[:locale] = params[:locale]
    end

    redirect_to settings_preferences_path, notice: t("settings.flash_updated")
  end
end
