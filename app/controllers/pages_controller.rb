class PagesController < ApplicationController
  before_action :authenticate_user!

  def search
  end

  def profile
    @user = current_user
  end

  def homepage
  end

  def matches
  end

end
