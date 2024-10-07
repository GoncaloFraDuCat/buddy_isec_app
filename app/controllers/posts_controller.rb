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


end
