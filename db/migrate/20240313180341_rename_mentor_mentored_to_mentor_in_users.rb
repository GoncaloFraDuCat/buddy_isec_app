class RenameMentorMentoredToMentorInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :mentor_mentored, :mentor
  end
end
