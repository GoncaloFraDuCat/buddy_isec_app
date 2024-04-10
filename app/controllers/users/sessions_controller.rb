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
      flash.now[:alert] = 'Invalid student ID or password.'
      render :new
    end
  end

  def destroy
    super
  end
end
