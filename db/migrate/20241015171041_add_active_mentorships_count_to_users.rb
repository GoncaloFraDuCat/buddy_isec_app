class AddActiveMentorshipsCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :active_mentorships_count, :integer, default: 0
  end
end
