class CreateUserCouses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_courses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.datetime :enrollment_date

      t.timestamps
    end
  end
end
