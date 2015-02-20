class PostsController < ApplicationController

  def create
    @post=current_user.posts.new(post_params)
    if @post.save
      @post_created_flag=true
    end
  end



  protected
  def post_params
    params.require(:post).permit(:title, :body);
  end

end
