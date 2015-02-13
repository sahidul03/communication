class MessagesController < ApplicationController

  def index
    @users=User.all
    @message=Message.new
    @user_id=current_user.id
   raise User.where("created_at >= :start_date AND id = :user_id",{start_date: "2015-02-11 07:08:25", user_id:1})[0].inspect


  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save()
      # redirect_to messages_path
    end
  end

  def message_load
    @user=current_user
    @recipient=User.find(params[:recipient_id])
    if(params[:LastDate]=="blank" || params[:LastDate]=="")
      @msgs_sent=current_user.sent_messages.where("recipient_id = ?", params[:recipient_id])
      @msgs_recipient=current_user.received_messages.where("sender_id = ?",params[:recipient_id])
    else
      @msgs_sent=current_user.sent_messages.where("recipient_id = :rcp_id AND created_at > :last_date", {rcp_id: params[:recipient_id],last_date: params[:LastDate]})
      @msgs_recipient=current_user.received_messages.where("sender_id = :snd_id AND created_at > :last_date",{snd_id: params[:recipient_id],last_date: params[:LastDate]})
    end
    @allmessage=@msgs_recipient+@msgs_sent
    @sortedallmessage= @allmessage.sort_by &:created_at
  end

  private

  def message_params
    params.require(:message).permit(:title, :body).merge(sender_id: current_user.id, recipient_id: params[:recipient_id]);
  end

end
