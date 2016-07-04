# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin1 = Admin.create(email: "admin@admin.com", password: "password", address: "32 Test St", city: "Boston", state: "MA", zip: "03333", admin: true)
teacher1 = Teacher.create(email: "teacher1@teacher.com", password: "password", address: "34 Test St", city: "Boston", state: "MA", zip: "03333", teacher: true)
Contact.create(first_name: "Jimmy", last_name: "Williams", email: "teacher1@teacher.com", phone: "9785551212", teacher: teacher1)
teacher2 = Teacher.create(email: "teacher2@teacher.com", password: "password", address: "36 Test St", city: "Boston", state: "MA", zip: "03333", teacher: true)
Contact.create(first_name: "Cody", last_name: "Daniels", email: "teacher2@teacher.com", phone: "9785551313", teacher: teacher2)
family1 = Family.create(email: "family1@family.com", password: "password", address: "38 Test St", city: "Boston", state: "MA", zip: "03333")
Contact.create(first_name: "Sam", last_name: "Williams", email: "family1@family.com", phone: "9785551313", family: family1)
Instrument.create(name: "Guitar")
Instrument.create(name: "Piano")
Instrument.create(name: "Violin")
Price.create(tier_name: "Private Lesson", price: "50", duration: "30")
Price.create(tier_name: "Suzuki Private Lesson", price: "75", duration: "45")
# Student.create(first_name: "Bob", last_name: "Smith", dob: "2001/02/10", account: family)
# Inquiry.create(instrument: "Piano", notes: "Preferred teacher Smith", student_id: 1, availabilities_attributes:  [{Availability.create(checked: "1", day: "Saturday", start_time: "2000-01-01 10:57:00 UTC", end_time: "2000-01-01 22:58:00 UTC", inquiry_id: 1)}}])
# # Availability.create(checked: "0", day: "Sunday", start_time: nil, end_time: nil, inquiry_id: 1)
# # Availability.create(checked: "0", day: "Monday", start_time: nil, end_time: nil, inquiry_id: 1)
# # Availability.create(checked: "0", day: "Tuesday", start_time: nil, end_time: nil, inquiry_id: 1)
# # Availability.create(checked: "0", day: "Wednesday", start_time: nil, end_time: nil, inquiry_id: 1)
# # Availability.create(checked: "0", day: "Thursday", start_time: nil, end_time: nil, inquiry_id: 1)
# # Availability.create(checked: "0", day: "Friday", start_time: nil, end_time: nil, inquiry_id: 1)
# # Availability.create(checked: "1", day: "Saturday", start_time: "2000-01-01 10:57:00 UTC", end_time: "2000-01-01 22:58:00 UTC", inquiry_id: 1)
