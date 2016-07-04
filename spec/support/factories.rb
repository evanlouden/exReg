FactoryGirl.define do
  factory :account do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    password_confirmation "password"
    address "32 Main Street"
    city "Boston"
    state "MA"
    zip "01223"
  end

  factory :teacher do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    password_confirmation "password"
    address "32 Main Street"
    city "Boston"
    state "MA"
    zip "01223"
    teacher true
  end

  factory :admin do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    password_confirmation "password"
    address "32 Main Street"
    city "Boston"
    state "MA"
    zip "01223"
    admin true
  end

  factory :student do
    first_name "John"
    last_name "Doe"
    dob "2000/05/13"
    account
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
    account
  end

  factory :contact do
    first_name "Sandra"
    last_name "Doe"
    sequence(:email) { |n| "user#{n}@example.com" }
    phone "9785551212"
    account
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
    student
    account
    inquiry
  end

  factory :instrument do
    name "Guitar"
  end
end
