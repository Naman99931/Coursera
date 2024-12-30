class AddStatusToUserCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :user_courses, :status, :string, default: "In progress"
  end
end
