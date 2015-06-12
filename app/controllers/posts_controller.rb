class PostsController < ApplicationController
  before_action :get_friend_list, :except => [:create]

  def create
    @post=current_user.posts.new(post_params)
    if @post.save
      @post_created_flag=true
    end
  end

 def show
   @post=Post.find(params[:id]) rescue nil
   unless @post
     # redirect to 404
   end
 end

  def notification_show
    notify=Notification.find(params[:id]) rescue nil
    if notify
      unless notify.seen
        notify.update(:seen=>true)
      end
      redirect_to user_post_url(:user_id=>notify.post.user.id,:id=>notify.post.id)
    end

  end


  protected
  def post_params
    params.require(:post).permit(:title, :body);
  end

end
