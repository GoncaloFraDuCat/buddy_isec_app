class AddForeignKeysToMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :mentorship_requests, :users, column: :mentor_id
    add_foreign_key :mentorship_requests, :users, column: :mentee_id
  end
end
