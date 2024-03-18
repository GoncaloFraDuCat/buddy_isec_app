class CreateMentorshipRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :mentorship_requests do |t|
      t.references :mentor, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
