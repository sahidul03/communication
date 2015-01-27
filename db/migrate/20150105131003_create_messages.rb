class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.text :body
      t.integer :sender_id
      t.integer :recipient_id


      t.timestamps
    end
  end
end
