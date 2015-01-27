class UsersController < ApplicationController


  def index
    @users=User.all
    @message=Message.new
    @user_id=current_user.id
    @cuuser=current_user
    @msgs_sent=current_user.sent_messages.where("recipient_id = ?", 1)
    @msgs_recipient=current_user.received_messages.where("sender_id = ?",1)
    @newarry=@msgs_recipient+@msgs_sent
    @sortedarr= @newarry.sort_by &:created_at
    # raise @sortedarr.inspect
  end

  def show
    @user=User.find(params[:id])
    @message = Message.new
  end
  def new
    @user=User.new
  end

  protected
  def user_params
    params.require(:user).permit(:name, :email, :username, :password, :reset_password);
  end


end
