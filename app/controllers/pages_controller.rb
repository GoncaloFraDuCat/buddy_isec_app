class PagesController < ApplicationController
  before_action :authenticate_user!


  def search
    @mentors = User.where(mentor: true).sample(4) || []
  end


  def profile
    @user = current_user
  end

  def homepage
  end

  def matches
  end

end
