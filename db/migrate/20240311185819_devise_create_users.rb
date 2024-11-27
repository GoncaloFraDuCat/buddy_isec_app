# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :student_id, null: false, default: ''

      t.timestamps null: false
    end

    add_index :users, :student_id, unique: true
  end
end
