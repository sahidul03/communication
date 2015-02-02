class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :profilepic, ProfilepicUploader

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id"

  has_many :sent_request, class_name: "UserFriend", foreign_key: "sender_id"
  has_many :received_request, class_name: "UserFriend", foreign_key: "recipient_id"

  has_many :posts

end
