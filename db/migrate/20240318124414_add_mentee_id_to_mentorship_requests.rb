class AddMenteeIdToMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :mentorship_requests, :mentee_id, :integer
  end
end
