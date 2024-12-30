class UserCourse < ApplicationRecord
   belongs_to :course, counter_cache: :users_count
   belongs_to :user, counter_cache: :courses_count

   before_create :set_enroll_date

   private
   def set_enroll_date
      self.enrollment_date = Date.today
   end
end