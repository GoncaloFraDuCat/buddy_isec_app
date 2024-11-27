class AddCheckConstraintToActiveMentorshipsCount < ActiveRecord::Migration[6.1]
  def change
    execute <<-SQL
      ALTER TABLE users
      ADD CONSTRAINT check_active_mentorships_count_non_negative
      CHECK (active_mentorships_count >= 0);
    SQL
  end
end
