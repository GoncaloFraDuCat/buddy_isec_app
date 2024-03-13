class PagesController < ApplicationController
  before_action :authenticate_user!

  def search
  end

  def profile
    unless current_user
       redirect_to new_user_session_path, alert: "You need to sign in before continuing."
       return
    end
    binding.pry
    @user = current_user
   end

  def homepage
  end

  def matches
  end
end
