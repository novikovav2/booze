class ProfileController < ApplicationController
  before_action :authenticate_user!

  # GET /profile
  def index
    @profile = current_user.profile
  end

  #POST /profile
  def new
    profile = current_user.create_profile
    profile.name = params[:name]
    profile.surname = params[:surname]
    respond_to do |format|
      if profile.save
        format.html { redirect_to profile_path, notice: 'Профиль успешно сохранен'}
      else
        format.html { redirect_to profile_path, alert: 'Ууупс... не получилось сохранить'}
      end
    end
  end

  # PATCH /profile
  def update
    profile = current_user.profile
    respond_to do |format|
      if profile.update(profile_params)
        format.html { redirect_to profile_path, notice: 'Профиль успешно сохранен'}
      else
        format.html { redirect_to profile_path, alert: 'Ууупс... не получилось сохранить'}
      end
    end
  end

  private
  def profile_params
    params.fetch(:profile, {}).permit(:name, :surname)
  end
end
