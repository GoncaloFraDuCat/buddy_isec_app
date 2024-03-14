# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(:student_id_authenticatable, scope: resource_name)
    if resource
      sign_in_and_redirect(resource)
   else
      # Handle the case where authentication fails
      # For example, you might want to re-render the sign-in form with an error message
      flash.now[:alert] = "Invalid student ID or password."
      render :new
   end
  end

  def destroy
    super
 end

  def show
    @user = User.find(params[:id])
    unless @user.mentor?
      redirect_to users_path, alert: "User is not a mentor."
  end
 protected

 def after_sign_in_path_for(resource)
    # Specify the path you want to redirect users to after sign-in
    # For example, to redirect to the profile page:
    search_path
    # Or, to redirect to the matches page:
    # matches_path
    # Or, to redirect to the search page:
    # search_path
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
end
