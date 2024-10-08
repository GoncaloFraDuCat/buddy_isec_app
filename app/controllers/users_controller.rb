class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = current_user

  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Bio was successfully updated.'
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
    params.require(:user).permit(
      :name,
      :email,
      :bio,
      :area_of_study,
      :current_year,
      :mentor,
      :student_id,
      :apoio_estudo,
      :ajuda_social,
      :apoio_bolsas,
      :photo
    )
  end
end
