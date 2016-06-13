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
end
