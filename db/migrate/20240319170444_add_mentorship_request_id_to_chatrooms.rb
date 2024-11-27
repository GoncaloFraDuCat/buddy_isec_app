class AddMentorshipRequestIdToChatrooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chatrooms, :mentorship_request_id, :integer
    add_index :chatrooms, :mentorship_request_id
  end
end
