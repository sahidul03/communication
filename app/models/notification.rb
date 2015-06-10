class Notification < ActiveRecord::Base
  belongs_to :maker, class_name: "User", primary_key: "maker_id"
  belongs_to :recipient, class_name: "User", primary_key: "recipient_id"
  belongs_to :post
end
