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
    @friend=current_user.sent_request.where("friend_type = ?",1)
    @friend_list=[]
    @friend.each do |frnd|
      temp_user=User.find(frnd.recipient_id)
      @friend_list<<temp_user
    end


  end

  def show
    @user=User.find(params[:id])
    # frndtype=current_user.sent_request
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
