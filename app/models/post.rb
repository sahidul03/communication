class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  validates :body, presence: true
end
