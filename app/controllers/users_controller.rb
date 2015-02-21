class UsersController < ApplicationController
  before_action :common_method

  def index
    @users=User.all
    @post=Post.new
    @user_p=User.new
    @message=Message.new
    @cuuser=current_user
    friend1=current_user.sent_request.where("friend_type = ?",1)
    friend2=current_user.received_request.where("friend_type = ?",1)
    @friend_list=[]
    @all_posts=[]
    if friend1.any?
      friend1.each do |frnd|
        temp_user=User.find(frnd.recipient_id)
        @friend_list<<temp_user
        pts=temp_user.posts
        if pts.any?
          pts.each do |p|
            @all_posts<<p
          end
        end

      end
    end
    if friend2.any?
      friend2.each do |frnd|
        temp_user=User.find(frnd.sender_id)
        @friend_list<<temp_user
        pts=temp_user.posts
        if pts.any?
          pts.each do |p|
            @all_posts<<p
          end
        end
      end
    end
    my_pts=current_user.posts
    if my_pts.any?
      my_pts.each do |p|
        @all_posts<<p
      end
    end
    @all_posts= @all_posts.sort_by &:created_at
    @all_posts.reverse!
     # raise @all_posts.inspect

    # testing purpose
    # post=Post.find(17)
    # like=post.like
    # if like==nil
    #   like=current_user.id.to_s;
    #   # raise like.inspect
    # else
    #   like_arry=like.split(',')
    #   # raise like_arry.inspect
    #   unless like_arry.include?(current_user.id)
    #     like=like+','+current_user.id.to_s
    #     raise like.inspect
    #   end
    #   # like=like+','+current_user.id.to_s
    # end
    # post.update(:like=>like)



  end

  def show
    @user=User.find(params[:id])
    @friend_comment='Add Friend'
    if current_user==@user
      @friend_comment='Me'
    else
      frndtype1=current_user.sent_request.where("friend_type = ? AND recipient_id = ?", 1 , params[:id])
      frndtype2=current_user.received_request.where("friend_type = ? AND sender_id = ?", 1, params[:id])
      frndtype3=current_user.received_request.where("friend_type = ? AND sender_id = ?", 2, params[:id])
      frndtype4=current_user.sent_request.where("friend_type = ? AND recipient_id = ?", 2, params[:id])
      if frndtype1.any? || frndtype2.any?
        @friend_comment='Friend'
      end
      if frndtype3.any?
        @friend_comment='Confirm or Cancel'
      end
      if frndtype4.any?
        @friend_comment='Request Sent'
      end
    end
  end


  def new
    @user=User.new
  end

  def search_friend
    @searched_friend=User.where("email like ?", "%#{params[:friend_name]}%")
  end

  def add_friend_request
    userfrnd=UserFriend.new({:sender_id=>current_user.id, :recipient_id=>params[:user_id], :friend_type=>2})
    if userfrnd.save()
      redirect_to user_path(params[:user_id])
    end
  end

  def confirm_friend_request
    usrfrnd=UserFriend.find_by("sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id)
    if usrfrnd.update(:friend_type=> 1)
      redirect_to user_path(params[:user_id])
    end
  end

  def confirm_friend_request_ajax
    usrfrnd=UserFriend.find_by("sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id)
    usrfrnd.update(:friend_type=> 1)
  end

  def cancel_friend_request
    usrfrnd=UserFriend.find_by("sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id)
    if usrfrnd.destroy()
      redirect_to user_path(params[:user_id])
    end
  end

  def cancel_friend_request_ajax
    usrfrnd=UserFriend.find_by("sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id)
    usrfrnd.destroy()
  end

  def load_received_friend_request_list
    usrfrnd=current_user.received_request.where("friend_type = ?", 2)
    @all_Friend_request=[]
    usrfrnd.each do |us|
      user=User.find(us.sender_id)
      @all_Friend_request<<user;
    end

  end

  def post_create

  end
  def post_like
    post=Post.find(params[:post_id])
    like=post.like
    if like==nil || like==''
      like=current_user.id.to_s;
    else
      like_arry=like.split(',')
      unless like_arry.include?(current_user.id.to_s)
        like=like+','+current_user.id.to_s
      end
    end
    post.update(:like=>like)
  end

  def show_all_likes
    post=Post.find(params[:post_id])
    like=post.like
    like_arry=like.split(',')
    @likers_list=[]
    like_arry.each do |u_id|
      if u_id==current_user.id
        @likers_list<<"You"
      else
        us=User.find(u_id)
        @likers_list<<us.name
      end
    end
  end

  def post_delete
    @post=Post.find(params[:post_id])
    if @post.user.id==current_user.id
      if @post.destroy
        @post_deleted_falg="true"
      else
        @post_deleted_falg="false"
      end
    end
  end

  def post_comment
    @post=Post.find(params[:post_id])
    @comment=@post.comments.new(:user_id=>current_user.id,:body=>params[:body])
    if @comment.save
      @post_comment_flag="true"
    else
      @post_comment_flag="false"
    end
  end


  protected
  def common_method
    @user_id=current_user.id
  end

  def user_params
    params.require(:user).permit(:name, :email, :username, :password, :reset_password);
  end
  def comment_params
    params.require(:comment).permit(:like).merge(user_id: current_user.id, body: params[:body]);
  end


end
