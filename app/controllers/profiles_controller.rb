class ProfilesController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_profile_path, notice: t("settings.profile_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :sip_number, :clinic_name, :clinic_address, :clinic_phone)
  end
end
