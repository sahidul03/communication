class PostsController < ApplicationController

  def create
    @post=current_user.posts.new(post_params)
    @post.save
  end

  def post_like

  end

  protected

  def post_params
    params.require(:post).permit(:title, :body);
  end

end
