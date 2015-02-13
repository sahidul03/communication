class AddLikeToPosts < ActiveRecord::Migration
  def change
    add_column :Posts, :like, :string
  end
end
