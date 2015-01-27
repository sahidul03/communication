class Message < ActiveRecord::Base
  belongs_to :sender, class_name: "User", primary_key: "sender_id"
  belongs_to :recipient, class_name: "User", primary_key: "recipient_id"


  validates :body, presence: true

end
