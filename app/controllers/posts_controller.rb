class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :ensure_mentor, only: [:new, :create, :edit, :update, :destroy]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      award_three_posts_badge if current_user.mentor? && current_user.posts.count == 3
      redirect_to profile_path, notice: 'Post created successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to profile_path, notice: 'Post updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post && @post.user == current_user
      @post.destroy
      remove_three_posts_badge if current_user.mentor? && current_user.posts.count < 3
      redirect_to profile_path(current_user), notice: "Post deleted successfully."
    else
      redirect_to profile_path(current_user), alert: "You don't have permission to delete this post."
    end
  end



  private


  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

  def ensure_mentor
    redirect_to root_path unless current_user.mentor?
  end

  def award_three_posts_badge
    badge = Badge.three_posts
    unless current_user.badges.exists?(name: badge.name)
      if current_user.mentor? && current_user.posts.count >= 3
        current_user.badges << badge
      end
    end
  end

  def remove_three_posts_badge
    badge = Badge.three_posts
    current_user.badges.where(name: badge.name).destroy_all if current_user.posts.count < 3
  end

end
