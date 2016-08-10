require "rails_helper"

feature "family views student's lessons history" do
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:reason1) { FactoryGirl.create(:reason) }
  let!(:absence_count) { FactoryGirl.create(:excused_absence) }
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
  let!(:contact3) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) {
    FactoryGirl.create(
      :inquiry,
      student: student1,
      completed: true)
  }
  let!(:lesson1) {
    FactoryGirl.create(
      :lesson,
      start_date: Date.today - 15,
      attended: 3,
      student: student1,
      teacher: teacher1,
      inquiry: inquiry1
    )
  }
  let!(:missed_lesson1) {
    FactoryGirl.create(
      :missed_lesson,
      date: Date.today - 8,
      lesson: lesson1,
      reason: reason1
    )
  }

  scenario "successfully views list of lessons" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    click_link student1.full_name

    expect(page).to have_content("#{lesson1.start_date.strftime('%m/%d/%y')} - Attended")
    expect(page).to have_content("#{(lesson1.start_date + 7).strftime('%m/%d/%y')} - Missed, #{reason1.reason}")
  end
end
