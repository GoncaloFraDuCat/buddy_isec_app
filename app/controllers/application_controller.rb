class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pagy::Backend

  protected

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
