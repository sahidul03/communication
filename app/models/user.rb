class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # devise :omniauthable, :omniauth_providers => [:facebook]
  # devise :omniauthable, :omniauth_providers => [:twitter]

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
      user.username=auth.info.username
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.profilepic = auth.info.image # assuming the user model has an image

      #Image save
      # r = open("#{auth.info.image}")
      # bytes = r.read
      # img = Magick::Image.from_blob(bytes).first
      # fmt = img.format
      # data=StringIO.new(bytes)
      # data.class.class_eval { attr_accessor :original_filename, :content_type }
      # data.original_filename = Time.now.to_i.to_s+"."+fmt
      # data.content_type='image.jpeg'
      # user.remote_profilepic_url = auth.info.image


      user.save!
      UserMailer.signup_confirmation(user).deliver
    end
  end




end
