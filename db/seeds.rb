# Administrative Settings
admin1 = Admin.create(
  email: "admin@exreg.com",
  password: "password",
  address: "32 Test St",
  city: "Boston",
  state: "MA",
  zip: "03333",
  admin: true,
  confirmed_at: Time.now
)

Contact.create(
  first_name: "Brad",
  last_name: "Stevens",
  email: admin1.email,
  phone: "9785551313",
  admin: admin1,
  primary: true
)

instrument1 = Instrument.create(name: "Piano")
instrument2 = Instrument.create(name: "Guitar")
instrument3 = Instrument.create(name: "Violin")
Price.create(tier_name: "Private Lesson", price: "50", duration: "30")
Price.create(tier_name: "Suzuki Private Lesson", price: "75", duration: "45")
Reason.create(reason: "Excused Absence", teacher_paid: false, student_charged: false)
Reason.create(reason: "Unexcused Absence", teacher_paid: true, student_charged: true)
ExcusedAbsence.create(count: "2")

# Teachers
teacher1_avails = [
  {
    checked: "1",
    day: "Sunday",
    start_time: "2000-01-01 14:00:00 UTC",
    end_time: "2000-01-01 16:00:00 UTC"
  },
  {
    checked: "1",
    day: "Monday",
    start_time: "2000-01-01 12:00:00 UTC",
    end_time: "2000-01-01 18:00:00 UTC"
  },
  {
    checked: "0",
    day: "Tuesday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Wednesday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Thursday",
    start_time: "2000-01-01 12:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "0",
    day: "Friday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Saturday",
    start_time: nil,
    end_time: nil
  }
]

teacher1_params = {
  email: "teacher1@exreg.com",
  password: "password",
  address: "100 Main St",
  city: "Boston",
  state: "MA",
  zip: "03333",
  teacher: true,
  confirmed_at: Time.now
}

teacher1 = Teacher.new(teacher1_params)

teacher1_avails.each do |a|
  teacher1.availabilities.build(a)
end

teacher1.save

Contact.create(
  first_name: "Terry",
  last_name: "Rozier",
  email: teacher1.email,
  phone: "9785551212",
  teacher: teacher1
)

TeacherInstrument.create(teacher: teacher1, instrument: instrument1)

teacher2_avails = [
  {
    checked: "0",
    day: "Sunday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Monday",
    start_time: "2000-01-01 11:00:00 UTC",
    end_time: "2000-01-01 18:00:00 UTC"
  },
  {
    checked: "1",
    day: "Tuesday",
    start_time: "2000-01-01 11:00:00 UTC",
    end_time: "2000-01-01 18:00:00 UTC"
  },
  {
    checked: "1",
    day: "Wednesday",
    start_time: "2000-01-01 11:00:00 UTC",
    end_time: "2000-01-01 17:00:00 UTC"
  },
  {
    checked: "0",
    day: "Thursday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Friday",
    start_time: "2000-01-01 13:00:00 UTC",
    end_time: "2000-01-01 16:00:00 UTC"
  },
  {
    checked: "0",
    day: "Saturday",
    start_time: nil,
    end_time: nil
  }
]

teacher2_params = {
  email: "teacher2@exreg.com",
  password: "password",
  address: "100 Main St",
  city: "Belmont",
  state: "MA",
  zip: "03333",
  teacher: true,
  confirmed_at: Time.now
}

teacher2 = Teacher.new(teacher2_params)

teacher2_avails.each do |a|
  teacher2.availabilities.build(a)
end

teacher2.save

Contact.create(
  first_name: "Jae",
  last_name: "Crowder",
  email: teacher2.email,
  phone: "9785551313",
  teacher: teacher2
)

TeacherInstrument.create(teacher: teacher2, instrument: instrument1)
TeacherInstrument.create(teacher: teacher2, instrument: instrument2)

teacher3_avails = [
  {
    checked: "1",
    day: "Sunday",
    start_time: "2000-01-01 09:00:00 UTC",
    end_time: "2000-01-01 13:00:00 UTC"
  },
  {
    checked: "0",
    day: "Monday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Tuesday",
    start_time: "2000-01-01 13:00:00 UTC",
    end_time: "2000-01-01 18:00:00 UTC"
  },
  {
    checked: "1",
    day: "Wednesday",
    start_time: "2000-01-01 13:00:00 UTC",
    end_time: "2000-01-01 18:00:00 UTC"
  },
  {
    checked: "1",
    day: "Thursday",
    start_time: "2000-01-01 12:00:00 UTC",
    end_time: "2000-01-01 16:00:00 UTC"
  },
  {
    checked: "0",
    day: "Friday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Saturday",
    start_time: nil,
    end_time: nil
  }
]

teacher3_params = {
  email: "teacher3@exreg.com",
  password: "password",
  address: "100 Main St",
  city: "Malden",
  state: "MA",
  zip: "03333",
  teacher: true,
  confirmed_at: Time.now
}

teacher3 = Teacher.new(teacher3_params)

teacher3_avails.each do |a|
  teacher3.availabilities.build(a)
end

teacher3.save

Contact.create(
  first_name: "Al",
  last_name: "Horford",
  email: teacher3.email,
  phone: "9785551313",
  teacher: teacher3
)

TeacherInstrument.create(teacher: teacher3, instrument: instrument2)

teacher4_avails = [
  {
    checked: "0",
    day: "Sunday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Monday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Tuesday",
    start_time: "2000-01-01 14:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "1",
    day: "Wednesday",
    start_time: "2000-01-01 13:00:00 UTC",
    end_time: "2000-01-01 19:00:00 UTC"
  },
  {
    checked: "1",
    day: "Thursday",
    start_time: "2000-01-01 13:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "0",
    day: "Friday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Saturday",
    start_time: nil,
    end_time: nil
  }
]

teacher4_params = {
  email: "teacher4@exreg.com",
  password: "password",
  address: "100 Main St",
  city: "Cambridge",
  state: "MA",
  zip: "03333",
  teacher: true,
  confirmed_at: Time.now
}

teacher4 = Teacher.new(teacher4_params)

teacher4_avails.each do |a|
  teacher4.availabilities.build(a)
end

teacher4.save

Contact.create(
  first_name: "Isaiah",
  last_name: "Thomas",
  email: teacher4.email,
  phone: "9785551414",
  teacher: teacher4
)

TeacherInstrument.create(teacher: teacher4, instrument: instrument2)
TeacherInstrument.create(teacher: teacher4, instrument: instrument3)

teacher5_avails = [
  {
    checked: "1",
    day: "Sunday",
    start_time: "2000-01-01 08:00:00 UTC",
    end_time: "2000-01-01 13:00:00 UTC"
  },
  {
    checked: "1",
    day: "Monday",
    start_time: "2000-01-01 12:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "1",
    day: "Tuesday",
    start_time: "2000-01-01 12:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "1",
    day: "Wednesday",
    start_time: "2000-01-01 13:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "1",
    day: "Thursday",
    start_time: "2000-01-01 14:00:00 UTC",
    end_time: "2000-01-01 21:00:00 UTC"
  },
  {
    checked: "0",
    day: "Friday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Saturday",
    start_time: nil,
    end_time: nil
  }
]

teacher5_params = {
  email: "teacher5@exreg.com",
  password: "password",
  address: "299 Main St",
  city: "Everett",
  state: "MA",
  zip: "03333",
  teacher: true,
  confirmed_at: Time.now
}

teacher5 = Teacher.new(teacher5_params)

teacher5_avails.each do |a|
  teacher5.availabilities.build(a)
end

teacher5.save

Contact.create(
  first_name: "Avery",
  last_name: "Bradley",
  email: teacher5.email,
  phone: "9785551515",
  teacher: teacher5
)

TeacherInstrument.create(teacher: teacher5, instrument: instrument1)
TeacherInstrument.create(teacher: teacher5, instrument: instrument3)


# Families
family1 = Family.create(
  email: "family1@exreg.com",
  password: "password",
  address: "505 Bridge Street",
  city: "Boston",
  state: "MA",
  zip: "03333",
  confirmed_at: Time.now
)

Contact.create(
  first_name: "Ted",
  last_name: "Williams",
  email: family1.email,
  phone: "9785559999",
  family: family1
)

student1_avails = [
  {
    checked: "0",
    day: "Sunday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Monday",
    start_time: "2000-01-01 15:00:00 UTC",
    end_time: "2000-01-01 19:00:00 UTC"
  },
  {
    checked: "1",
    day: "Tuesday",
    start_time: "2000-01-01 14:00:00 UTC",
    end_time: "2000-01-01 19:00:00 UTC"
  },
  {
    checked: "1",
    day: "Wednesday",
    start_time: "2000-01-01 15:00:00 UTC",
    end_time: "2000-01-01 19:00:00 UTC"
  },
  {
    checked: "0",
    day: "Thursday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Friday",
    start_time: "2000-01-01 14:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "1",
    day: "Saturday",
    start_time: "2000-01-01 08:00:00 UTC",
    end_time: "2000-01-01 14:00:00 UTC"
  }
]

student1_params = {
  first_name: "Jimmy",
  last_name: "Williams",
  dob: "1996/07/20",
  family: family1
}

student1 = Student.new(student1_params)

student1_avails.each do |a|
  student1.availabilities.build(a)
end

inquiry1 = {
  instrument: "Guitar",
  student_id: student1,
  completed: false
}

student1.inquiries.build(inquiry1)

student1.save

family2 = Family.create(
  email: "family2@exreg.com",
  password: "password",
  address: "406 Oak Ave",
  city: "Boston",
  state: "MA",
  zip: "03333",
  confirmed_at: Time.now
)

Contact.create(
  first_name: "David",
  last_name: "Ortiz",
  email: family2.email,
  phone: "9785558888",
  family: family2
)

student2_avails = [
  {
    checked: "1",
    day: "Sunday",
    start_time: "2000-01-01 08:00:00 UTC",
    end_time: "2000-01-01 13:00:00 UTC"
  },
  {
    checked: "1",
    day: "Monday",
    start_time: "2000-01-01 13:30:00 UTC",
    end_time: "2000-01-01 18:30:00 UTC"
  },
  {
    checked: "0",
    day: "Tuesday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Wednesday",
    start_time: "2000-01-01 14:30:00 UTC",
    end_time: "2000-01-01 19:00:00 UTC"
  },
  {
    checked: "1",
    day: "Thursday",
    start_time: "2000-01-01 15:00:00 UTC",
    end_time: "2000-01-01 18:00:00 UTC"
  },
  {
    checked: "0",
    day: "Friday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Saturday",
    start_time: nil,
    end_time: nil
  }
]

student2_params = {
  first_name: "Manny",
  last_name: "Ortiz",
  dob: "1994/04/12",
  family: family2
}

student2 = Student.new(student2_params)

student2_avails.each do |a|
  student2.availabilities.build(a)
end

inquiry2 = {
  instrument: "Piano",
  student_id: student2,
  completed: false
}

student2.inquiries.build(inquiry2)

student2.save

student3_avails = [
  {
    checked: "1",
    day: "Sunday",
    start_time: "2000-01-01 09:00:00 UTC",
    end_time: "2000-01-01 12:00:00 UTC"
  },
  {
    checked: "1",
    day: "Monday",
    start_time: "2000-01-01 14:00:00 UTC",
    end_time: "2000-01-01 20:00:00 UTC"
  },
  {
    checked: "1",
    day: "Tuesday",
    start_time: "2000-01-01 15:00:00 UTC",
    end_time: "2000-01-01 20:30:00 UTC"
  },
  {
    checked: "0",
    day: "Wednesday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "1",
    day: "Thursday",
    start_time: "2000-01-01 14:30:00 UTC",
    end_time: "2000-01-01 20:30:00 UTC"
  },
  {
    checked: "0",
    day: "Friday",
    start_time: nil,
    end_time: nil
  },
  {
    checked: "0",
    day: "Saturday",
    start_time: nil,
    end_time: nil
  }
]

student3_params = {
  first_name: "Alexandra",
  last_name: "Ortiz",
  dob: "1992/10/07",
  family: family2
}

student3 = Student.new(student3_params)

student3_avails.each do |a|
  student3.availabilities.build(a)
end

inquiry3 = {
  instrument: "Violin",
  student_id: student3,
  completed: false
}

student3.inquiries.build(inquiry3)

student3.save
