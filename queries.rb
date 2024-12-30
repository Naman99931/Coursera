# Coursera 50 queries :

#  1--> List all individuals who have signed up on the platform.
User.all    #this query will return details of all the users

#  2--> Find the total number of courses available.
Course.count   #this query count the total no. of available courses

#  3--> Retrieve the details of all individuals enrolled in a specific course.
   # by using id :
   c = Course.find(id)
   c.users

   #by using name :
   c = Course.find_by(name:"Ruby")
   c.users

#  4--> Fetch the names of all courses in which a specific individual is enrolled.
   # by using id :
   User.find(4).courses

   #by using name :
   User.find_by(name:"Ram").courses

#  5--> Count how many people are enrolled in each course
# by using counter_cache , i added a users_count coloumn to courses table
Course.pluck(:name,:users_count)
o/p :  [["Ruby", 1], ["Rails", 3], ["Java", 0], ["React", 0]]

#  6--> Identify the course with the most enrollments.
Course.order(users_count: :desc).first
o/p : id: 2,
name: "Rails",
created_at: Sat, 28 Dec 2024 18:46:00.286847000 UTC +00:00,
updated_at: Sat, 28 Dec 2024 18:46:00.286847000 UTC +00:00,
users_count: 3>

#  7--> List all enrollments where the status is marked as "completed."
# firstly i have added a coloumn 'status' in user_courses table , then updated records 
completed_enrollments = UserCourse.where(status: "completed")
completed_enrollments

o/p : [#<UserCourse:0x00007f60f4f35a00
id: 1,
user_id: 3,
course_id: 1,
enrollment_date: nil,
created_at: Sat, 28 Dec 2024 19:26:30.066121000 UTC +00:00,
updated_at: Sun, 29 Dec 2024 07:28:40.054788000 UTC +00:00,
status: "completed">]

#  8--> Fetch details of individuals who enrolled within the last 7 days.
# we have already added a coloumn in user_courses table : 'enrollment_date' , which we will use in this query
User.joins(:user_courses).where("enrollment_date >= ?", 7.days.ago)

o/p : [#<User:0x00007f60f5a9bc28
id: 1,
name: "Naman",
created_at: Sat, 28 Dec 2024 19:24:08.942722000 UTC +00:00,
updated_at: Sat, 28 Dec 2024 19:24:08.942722000 UTC +00:00>,
#<User:0x00007f60f5a9b228
id: 2,
name: "Jain",
created_at: Sat, 28 Dec 2024 19:24:32.233487000 UTC +00:00,
updated_at: Sat, 28 Dec 2024 19:24:32.233487000 UTC +00:00>,
#<User:0x00007f60f5a9a328
id: 3,
name: "Anshika",
created_at: Sat, 28 Dec 2024 19:26:29.974473000 UTC +00:00,
updated_at: Sat, 28 Dec 2024 19:26:29.974473000 UTC +00:00>]

#  9--> List all courses that were created within the last month.
Course.where("created_at >= ?", 60.days.ago).where("created_at <= ?", 30.days.ago)
o/p : [#<Course:0x00007f60f47e39a0
id: 4,
name: "Java",
created_at: Sun, 24 Nov 2024 11:23:16.068608000 UTC +00:00,
updated_at: Sun, 29 Dec 2024 11:23:16.070892000 UTC +00:00,
users_count: 0>]

#  10--> Retrieve the names and enrollment dates of all individuals enrolled in a specific course
enroll = UserCourse.joins(:user,:course).where(courses:{name:"Rails"})
         .select("users.name AS user_name, user_courses.enrollment_date AS enrollment_date")

enroll.each do |t|
   puts "User Name: #{t.user_name}, Enrolled At: #{t.enrollment_date}"
end
o/p : User Name: Naman, Enrolled At: 2024-12-29 00:00:00 UTC
      User Name: Jain, Enrolled At: 2024-12-29 00:00:00 UTC
      User Name: Anshika, Enrolled At: 2024-12-29 00:00:00 UTC

#  11--> Find the names of individuals who have not enrolled in any course.
# by using counter_cache 
unenroll_users = User.where(courses_count:  0)

unenroll_users.each do |t|
   puts "User Name: #{t.name}"
end
o/p : [#<User:0x00007fe58aaa17d0
id: 3,
name: "Aditya",
created_at: Sun, 29 Dec 2024 18:04:16.079114000 UTC +00:00,
updated_at: Sun, 29 Dec 2024 18:04:16.079114000 UTC +00:00,
courses_count: 0>]

#  12--> Update the enrollment status of a specific individual to "completed."
UserCourse.find_by(user_id:2,course_id:2).update(status:"completed")
 o/p : true  # it will give the updated value if we print it

#  13--> Remove a specific enrollment from the system.
UserCourse.find_by(user_id:2,course_id:2).delete
o/p : #<UserCourse:0x00007fe58a0f7950
id: 5,
user_id: 2,
course_id: 2,
enrollment_date: Sun, 29 Dec 2024 00:00:00.000000000 UTC +00:00,
created_at: Sun, 29 Dec 2024 18:07:22.052408000 UTC +00:00,
updated_at: Sun, 29 Dec 2024 18:22:56.783318000 UTC +00:00,
status: "completed">

#  14-->Retrieve all courses along with the count of their enrollments.
Course.select(:name,:users_count)
o/p : 
[<Course:0x00007fe58a0fdc10 id: nil, name: "Ruby", users_count: 1>,
 <Course:0x00007fe58a0fdad0 id: nil, name: "Rails", users_count: 2>,
 <Course:0x00007fe58a0fd990 id: nil, name: "Java", users_count: 2>]

 # or we can use pluck
 Course.pluck(:name,:users_count)
 o/p : 
 [["Ruby", 1], ["Rails", 2], ["Java", 2]]

 #  15-->Identify individuals who are enrolled in more than three courses.
 user = User.where("courses_count > ?",3)

 user.each do |t|
      puts "User Name: #{t.name},enrolled courses: #{t.courses_count}"
 end

 #  16-->Find courses that have fewer than five enrollments.
 c = Course.where("users_count < ?",5)

 c.each do |t|
      puts "Course name:#{t.name},enrolled users:#{t.users_count}"
 end
 o/p :
 Course name:Ruby,enrolled users:2
Course name:Rails,enrolled users:2
Course name:Java,enrolled users:2
Course name:Python,enrolled users:2

 #  17-->List all individuals who have enrolled in multiple courses.
 user = User.where("courses_count > ?",1)

 user.each do |t|
      puts "User Name: #{t.name},enrolled courses: #{t.courses_count}"
 end
o/p : 
 User Name: Naman,enrolled courses: 4
User Name: Animesh,enrolled courses: 4


#  18-->Fetch the latest enrollment for each individual. 
doubt

#  19-->Retrieve all courses sorted by the number of enrollments in descending order.
Course.order(users_count: :desc)

#  20-->Find the average number of enrollments per course.
Course.average(:users_count).to_f
o/p : 2.0

#  21-->Fetch the total number of enrollments on the platform.
UserCourse.count
o/p : 6

#  22-->Retrieve the details of the individual who has been enrolled the longest in a specific course.
longest_enroll = UserCourse.joins(:user).where(course_id:2).order(:enrollment_date).first

#  23--> List all enrollments where the status is "dropped.
UserCourse.where(status:"dropped")
o/p : 
[#<UserCourse:0x00007fe58a024b18
id: 6,
user_id: 1,
course_id: 4,
enrollment_date: Mon, 30 Dec 2024 00:00:00.000000000 UTC +00:00,
created_at: Sun, 29 Dec 2024 18:46:55.266323000 UTC +00:00,
updated_at: Sun, 29 Dec 2024 20:13:19.664436000 UTC +00:00,
status: "dropped">]

#  24-->Identify courses that no one has enrolled in.
Course.where(users_count:0)

o/p :
[#<Course:0x00007fe58a024618
id: 5,
name: "Mern",
created_at: Sun, 29 Dec 2024 20:16:04.449921000 UTC +00:00,
updated_at: Sun, 29 Dec 2024 20:16:04.449921000 UTC +00:00,
users_count: 0>]

#  25-->Find the top five individuals with the most enrollments.
u = User.order(courses_count: :desc).limit(5)

#  26-->Retrieve the most recently created course.
Course.order(created_at: :desc).limit(1)

o/p : 
[#<Course:0x00007fe58a0c58d8
id: 5,
name: "Mern",
created_at: Sun, 29 Dec 2024 20:16:04.449921000 UTC +00:00,
updated_at: Sun, 29 Dec 2024 20:16:04.449921000 UTC +00:00,
users_count: 0>]

#  27-->Find the individual with the highest number of completed enrollments.
doubt

#  28-->Fetch all courses and include the names of individuals enrolled in each course.
course_users = Course.joins(:user_courses).joins(:users).select("courses.name AS course_name , users.name AS user_name")


#  29-->List all enrollments for individuals who signed up within the last month.
last_month_users = User.joins(:user_courses).where("users.created_at >= ?", 1.month.ago)


#  30-->Identify all individuals who are currently enrolled in at least one course.
users_with_enrollments = User.joins(:user_courses).distinct

#  31-->Retrieve the names of all courses where enrollment is still open.
# i have created a new column 'enrollment_status'
open_courses = Course.where(enrollment_status: "open")


#  32--> Count how many individuals have completed at least one course.
complete_course = UserCourse.where(status: "completed").distinct.count(:user_id)

#  33--> Retrieve the total number of enrollments for a specific individual.
user = User.find_by(name:"Naman")
total_enrol = user.user_courses.count

#  34--> Find individuals who enrolled in a specific course on a specific date.
enroll = UserCourse.joins(:user, :course).where(course_id: 1, enrollment_date: Date.yesterday)

#  35--> Update the name of a specific course
course = Course.find_by(name:"Python")
course.update(name:"Django")

#  36--> Delete a specific course from the system.
 # for this i have used dependent destroy 
 course = Course.find_by(name:"Django")
 course.destroy

#  37--> Retrieve all courses along with the average duration of enrollments.
# added a new coloumn in course table
Course.average("duration").to_f

#  38--> Fetch the details of enrollments that were updated in the last 24 hours.
enrol = UserCourse.where("updated_at >= ?", 24.hours.ago)

#  39--> Retrieve the count of courses where enrollment is marked as "active."
course = Course.joins(:user_courses).where(user_courses: { status:"In progress"}).distinct.count

o/p : 3

