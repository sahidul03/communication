class CreateUserFriends < ActiveRecord::Migration
  def change
    create_table :user_friends do |t|

      t.integer :sender_id
      t.integer :recipient_id
      t.integer :friend_type

      t.timestamps
    end
  end
end
