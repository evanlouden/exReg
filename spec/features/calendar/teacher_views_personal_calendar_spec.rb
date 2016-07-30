require "rails_helper"

feature "teacher views personal calendar", js: true do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:contact1) {
    FactoryGirl.create(
      :contact,
      admin: admin1,
      email: admin1.email,
      first_name: "Bernie",
      last_name: "Sanders"
    )
  }
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact2) { FactoryGirl.create(:contact, email: teacher1.email, teacher: teacher1) }
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) {
    FactoryGirl.create(
      :inquiry,
      student: student1,
      completed: true)
  }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:lesson1) {
    FactoryGirl.create(
      :lesson,
      student: student1,
      teacher: teacher1,
      inquiry: inquiry1
    )
  }

  scenario "successfully views calendar" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"

    within(:css, "##{lesson1.day}-0800PM") do
      find(:xpath, ".//div[@id='lesson-#{lesson1.day}-0800PM']")
    end
  end
end
