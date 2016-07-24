FactoryGirl.define do
  factory :account, class: 'Account' do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    password_confirmation "password"
    address "32 Main Street"
    city "Boston"
    state "MA"
    zip "01223"
  end

  factory :admin, parent: :account, class: 'Admin' do
    admin true
  end

  factory :teacher, parent: :account, class: 'Teacher' do
    teacher true
    before(:create) do |teacher|
      teacher.availabilities << FactoryGirl.build(:availability)
      teacher.availabilities << FactoryGirl.build(:availability, day: "Monday", checked: "0", start_time: "", end_time: "")
    end
  end

  factory :family, parent: :account, class: 'Family' do
  end

  factory :student do
    first_name "John"
    last_name "Doe"
    dob "2000/05/13"
    family
    before(:create) do |student|
      student.availabilities << FactoryGirl.build(:availability)
      student.availabilities << FactoryGirl.build(:availability, day: "Monday", checked: "0", start_time: "", end_time: "")
    end
  end

  factory :inquiry do
    instrument "Guitar"
    student
  end

  factory :availability do
    checked "1"
    day "Sunday"
    start_time "2000-01-01 20:00:00 UTC"
    end_time "2000-01-01 22:00:00 UTC"
  end

  factory :contact do
    first_name "Sandra"
    last_name "Doe"
    sequence(:email) { |n| "user#{n}@example.com" }
    phone "9785551212"
    primary true
  end

  factory :price do
    tier_name "Suzuki Private Lesson"
    duration "45"
    price "75"
  end

  factory :lesson do
    day "Sunday"
    start_date "2016/08/20"
    start_time "2000-01-01 20:00:00 UTC"
    purchased "12"
    attended "0"
    instrument "Guitar"
    tier_name "Suzuki Private Lesson"
    duration "45"
    price "75"
    excused_remaining "3"
    student
    teacher
    inquiry
  end

  factory :instrument do
    name "Guitar"
  end

  factory :reason do
    reason "Excused Absence"
    teacher_paid false
    student_charged false
  end

  factory :teacher_instrument do
  end

  factory :excused_absence do
    count "3"
  end
end
