require "rails_helper"

feature "admin views list of students lessons for teachers" do
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
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact2) {
    FactoryGirl.create(
      :contact,
      family: family1,
      email: family1.email,
      first_name: "Jim",
      last_name: "Doe",
      primary: true
    )
  }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:price2) { FactoryGirl.create(:price, duration: "60", price: "100") }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:lesson1) {
    FactoryGirl.create(
      :lesson,
      student: student1,
      teacher: teacher1,
      inquiry: inquiry1
    )
  }
  let!(:contact3) { FactoryGirl.create(:contact, teacher: teacher1) }
  let!(:count1) { FactoryGirl.create(:excused_absence) }

  scenario "successfully views list" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link "All Staff"
    click_link teacher1.staff_name

    expect(page).to have_content(student1.full_name)
    expect(page).to have_content(contact2.email)
  end
end
