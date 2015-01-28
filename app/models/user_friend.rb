class UserFriend < ActiveRecord::Base
  belongs_to :request_sender, class_name: "User", primary_key: "sender_id"
  belongs_to :request_recipient, class_name: "User", primary_key: "recipient_id"
end
