class ChangeMenteeIdAndMentorIdToBigintInMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    change_column :mentorship_requests, :mentor_id, :bigint
  end
end
