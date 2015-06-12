class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?


  def get_friend_list
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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :username, :profilepic) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :name, :username, :profilepic) }
  end
end
