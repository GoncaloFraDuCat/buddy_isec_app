class RemoveForeignKeyFromMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :mentorship_requests, :mentors
  end
end
