class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'Bio was successfully updated.'
    else
      render :edit
    end
  end

   def index
    @users = User.by_area_of_study(params[:area_of_study])
      @pagy, @users = pagy(User.all, items: 8)
  end

  private

  def user_params
    params.require(:user).permit(:bio, :photo)
  end
end
