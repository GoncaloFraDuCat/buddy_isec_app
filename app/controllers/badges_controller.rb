# app/controllers/roller.rb
class BadgesController < ApplicationController
  def show
    @badge = Badge.find(params[:id])
  end

  def index
    @all_badges = Badge.all
  end
end
