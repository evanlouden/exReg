require "rails_helper"

feature "admin views student's lessons" do
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
  let!(:contact2) { FactoryGirl.create(:contact, teacher: teacher1) }
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact3) {
    FactoryGirl.create(
      :contact,
      family: family1,
      email: family1.email,
      first_name: "Jim",
      last_name: "Doe"
    )
  }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) {
    FactoryGirl.create(
      :inquiry,
      student: student1,
      completed: true
    )
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

  scenario "views list of lessons" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    fill_in :query, with: student1.last_name
    click_button "Search"
    click_link student1.full_name
    click_link student1.full_name

    expect(page).to have_content(lesson1.time_info)
    expect(page).to have_content(lesson1.price_info)
    expect(page).to have_content(lesson1.teacher.staff_name)
  end
end
