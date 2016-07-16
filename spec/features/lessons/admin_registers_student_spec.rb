require "rails_helper"

feature "admin registers student for lessons", js: true do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:user1) { FactoryGirl.create(:family) }
  let!(:student1) { FactoryGirl.create(:student, family: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:price2) { FactoryGirl.create(:price, duration: "60", price: "100") }
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact1) { FactoryGirl.create(:contact, teacher: teacher1) }
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
    click_link student1.full_name
    click_link "Register Student"
    select(price2.description, from: "Pricing Tier")
    find(:css, "#lesson_start_date").set("2016/09/13")
    find('label', text: 'Start Time').click

    page.has_css?('input', text: 'Wednesday', visible: false)

    fill_in "Start Time", with: "8:00 PM"
    fill_in "Purchased", with: "10"
    select("Guitar", from: "Instrument")
    select(teacher1.full_name, from: "Teacher")
    click_button "Register Student"

    expect(page).to have_content("Student Registered")

    click_link "Students"
    click_link student1.full_name

    expect(page).to have_content("#{inquiry1.instrument} - Completed")
    expect(page).to_not have_content("Register Student")
  end

  scenario "does not specify required information" do
    within(:css, "#admin-inquiries") do
      click_link student1.full_name
    end
    click_link "Register Student"
    click_button "Register Student"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("Register #{student1.full_name}")
  end
end
