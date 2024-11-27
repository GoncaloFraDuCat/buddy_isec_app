class ChangeMenteeIdToBigintInMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    change_column :mentorship_requests, :mentee_id, :bigint
  end
end
