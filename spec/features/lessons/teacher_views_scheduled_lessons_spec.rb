require "rails_helper"

feature "teacher views list of scheduled lessons" do
  let!(:admin1) { FactoryGirl.create(:account, admin: true) }
  let!(:teacher1) { FactoryGirl.create(:account, teacher: true) }
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:price2) { FactoryGirl.create(:price, duration: "60", price: "100") }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:lesson1) { FactoryGirl.create(:lesson, student: student1, account: teacher1, inquiry: inquiry1) }
  let!(:contact1) { FactoryGirl.create(:contact, account: teacher1) }

  scenario "successfully views list" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"

    expect(page).to have_content("Welcome, #{teacher1.contacts.first.full_name}")
    expect(page).to have_content("#{student1.full_name} - #{lesson1.instrument}")
  end
end
