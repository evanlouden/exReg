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

  factory :student do
    first_name "John"
    last_name "Doe"
    dob "2000/05/13"
    account
  end

  factory :inquiry do
    instrument "Guitar"
    student
    before(:create) do |inquiry|
      inquiry.availabilities << FactoryGirl.build(:availability)
    end
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
    account
  end
end
