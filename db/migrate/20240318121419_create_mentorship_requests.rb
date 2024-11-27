class CreateMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :mentorship_requests do |t|
      t.string :status

      t.timestamps
    end
  end
end
