class AddCreatedAtToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :createdAt, :datetime
  end
end
