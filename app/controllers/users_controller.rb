class UsersController < ApplicationController
  before_action :common_method

  def index
    @users=User.all
    @message=Message.new
    @cuuser=current_user
    # @msgs_sent=current_user.sent_messages.where("recipient_id = ?", 1)
    # @msgs_recipient=current_user.received_messages.where("sender_id = ?",1)
    # @newarry=@msgs_recipient+@msgs_sent
    # @sortedarr= @newarry.sort_by &:created_at
    friend1=current_user.sent_request.where("friend_type = ?",1)
    friend2=current_user.received_request.where("friend_type = ?",1)
    @friend_list=[]
    if friend1.any?
      friend1.each do |frnd|
        temp_user=User.find(frnd.recipient_id)
        @friend_list<<temp_user
      end
    end
    if friend2.any?
      friend2.each do |frnd|
        temp_user=User.find(frnd.sender_id)
        @friend_list<<temp_user
      end
    end
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

  protected
  def common_method
    @user_id=current_user.id
  end

  def user_params
    params.require(:user).permit(:name, :email, :username, :password, :reset_password);
  end


end
