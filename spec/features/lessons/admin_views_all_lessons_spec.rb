require "rails_helper"

feature "admin views all lessons" do
  let!(:admin1) { FactoryGirl.create(:account, admin: true) }
  let!(:teacher1) { FactoryGirl.create(:account, teacher: true) }
  let!(:family1) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1, completed: true) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:lesson1) { FactoryGirl.create(:lesson, student: student1, account: family1, inquiry: inquiry1) }

  scenario "views list of lessons" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link "All Lessons"

    expect(page).to have_content("#{lesson1.remaining} lessons remaining")
    expect(page).to have_content("$#{lesson1.remaining_balance}")
    expect(page).to have_content("#{lesson1.student.first_name} #{lesson1.student.last_name} - #{lesson1.instrument}")
  end
end
