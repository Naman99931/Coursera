class AddUsersCountToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :users_count, :integer, default: 0, null: false
  end
end
