class ApplicationController < ActionController::Base

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
