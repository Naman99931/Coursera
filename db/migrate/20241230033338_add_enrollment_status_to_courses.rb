class AddEnrollmentStatusToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :enrollment_status, :string, default: "Open"
  end
end
