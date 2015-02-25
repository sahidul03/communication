class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  mount_uploader :profilepic, ProfilepicUploader

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id"

  has_many :sent_request, class_name: "UserFriend", foreign_key: "sender_id"
  has_many :received_request, class_name: "UserFriend", foreign_key: "recipient_id"

  has_many :posts
  has_many :comments


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      usr=Devise.friendly_token[0,20]
      user.username=usr
      user.password = "abcd1234"
      user.name = auth.info.name   # assuming the user model has a name
      user.profilepic = auth.info.image # assuming the user model has an image
    end
  end

end
