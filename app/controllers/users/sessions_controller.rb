# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by(student_id: params[:user][:student_id])

    if user.present?
      # sign_in(user)
      # Redirect the user to the desired page after successful login
      redirect_to root_path
    else
      # Handle the case where the user does not exist
      flash[:alert] = "User not found."
      redirect_to new_user_session_path
    end

  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
