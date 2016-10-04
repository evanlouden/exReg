require "rails_helper"

feature "teacher views list of scheduled lessons" do
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
      last_name: "Doe"
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
    sign_in_as(teacher1)
    click_link "My Students"
    click_link student1.full_name

    expect(page).to have_content(count1.count)
    expect(page).to have_content(lesson1.instrument)
  end
end
