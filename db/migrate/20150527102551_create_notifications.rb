class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :body
      t.references :post, index: true
      t.boolean :seen
      t.integer :maker_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
