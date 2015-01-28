class UsersController < ApplicationController


  def index
    @users=User.all
    @message=Message.new
    @user_id=current_user.id
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
  def new
    @user=User.new
  end

  def search_friend
    @searched_friend=User.where("email like ?", "%#{params[:friend_name]}%")
  end

  protected
  def user_params
    params.require(:user).permit(:name, :email, :username, :password, :reset_password);
  end


end
