class UsersController < ApplicationController
  before_action :common_method, :get_friend_list, :except => [:search_friend,:add_friend_request,:confirm_friend_request,:confirm_friend_request_ajax,
                                                              :cancel_friend_request,:cancel_friend_request_ajax,:load_notification,:post_comment,
                                                              :post_create,:post_delete,:post_like,:show_all_likes,:load_received_friend_request_list,
                                                              :load_notification, :index]

  def index
    @users=User.all
    @post=Post.new
    @user_p=User.new
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
  end

  def show
    @user=User.find(params[:id]) rescue nil
    if @user
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
    else
      redirect_to users_path
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
      unless post.nil?
        already_liked=post.likes.where(:user_id=>current_user.id)
        unless already_liked.any?
          like=post.likes.create(:user_id=>current_user.id)
          unless current_user==post.user
            notify_body='likes your post'
            notify=post.notifications.build(:body=>notify_body,:seen=>false,:maker_id=>current_user.id,:recipient_id=>post.user.id)
            notify.save
          end
        end
      end
  end

  def show_all_likes
    post=Post.find(params[:post_id])
    @all_likes=post.likes
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
      unless current_user==@post.user
        notify_body='comments on your post'
        notify=@post.notifications.build(:body=>notify_body,:seen=>false,:maker_id=>current_user.id,:recipient_id=>@post.user.id)
        notify.save
      end
      commented_user=[]
      if @post.comments.any?
        commenter=@post.comments
        commented_user=commenter+commenter
        commented_user.uniq! {|e| e[:user_id] }
        commented_user.each do |cmnt|
          unless current_user==cmnt.user
            unless @post.user==cmnt.user
              notify_body='comments on '+@post.user.name+"'s post of you"
              notify=@post.notifications.build(:body=>notify_body,:seen=>false,:maker_id=>current_user.id,:recipient_id=>cmnt.user.id)
              notify.save
            end
          end
        end
      end
    else
      @post_comment_flag="false"
    end
  end

  def load_notification
    @all_notifications=current_user.received_notification.last(7)
  end

  def pagination_sample
    @users = User.order(:name).page(params[:page]).per(2)
    # raise User.all.count.inspect
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
