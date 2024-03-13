class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :area_of_study, :string
    add_column :users, :current_year, :integer
    add_column :users, :mentor_mentored, :boolean
  end
end
