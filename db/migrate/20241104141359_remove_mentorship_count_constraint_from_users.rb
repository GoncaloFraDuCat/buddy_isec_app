class RemoveMentorshipCountConstraintFromUsers < ActiveRecord::Migration[6.1]
  def up
    remove_check_constraint :users, name: "check_active_mentorships_count_non_negative"
  end

  def down
    add_check_constraint :users, "COUNT(*) >= 0", name: "check_active_mentorships_count_non_negative"
  end
end
