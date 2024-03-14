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
    sign_in_and_redirect resource and return if resource
  end

  def destroy
    super
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
