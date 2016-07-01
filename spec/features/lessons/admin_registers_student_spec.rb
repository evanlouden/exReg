require "rails_helper"

feature "admin registers student for lessons" do
  let!(:admin1) { FactoryGirl.create(:account, admin: true) }
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:price2) { FactoryGirl.create(:price, duration: "60", price: "100") }
  let!(:teacher1) { FactoryGirl.create(:account, teacher: true) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "specifies valid information" do
    click_link "Students"
    click_link "#{student1.full_name}"
    click_link "Register Student"
    select("#{price2.description}", from: "Pricing Tier")
    fill_in "Start Date", with: "2016/09/13"
    select("Monday", from: "Day")
    fill_in "Start Time", with: "8:00 PM"
    fill_in "Purchased", with: "10"
    select("Guitar", from: "Instrument")
    select("#{teacher1.email}", from: "Teacher")
    click_button "Register Student"

    expect(page).to have_content("Student Registered")

    click_link "Students"
    click_link "#{student1.full_name}"

    expect(page).to have_content("#{inquiry1.instrument} - Completed")
    expect(page).to_not have_content("Register Student")
  end

  scenario "does not specify required information" do
    within(:css, "#admin-inquiries") do
      click_link "#{student1.full_name}"
    end
    click_link "Register Student"
    click_button "Register Student"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("Register #{student1.full_name}")
  end
end
