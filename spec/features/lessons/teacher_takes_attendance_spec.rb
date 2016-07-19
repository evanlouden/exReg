require "rails_helper"

feature "teacher takes attendance", js: true do
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
  let!(:user1) { FactoryGirl.create(:family) }
  let!(:student1) { FactoryGirl.create(:student, family: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:price2) { FactoryGirl.create(:price, duration: "60", price: "100") }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:lesson1) {
    FactoryGirl.create(
      :lesson,
      student: student1,
      teacher: teacher1,
      inquiry: inquiry1,
      start_date: Date.today.strftime("%F"),
      day: Date.today.strftime("%A")
    )
  }
  let!(:contact2) { FactoryGirl.create(:contact, teacher: teacher1) }
  let!(:reason1) { FactoryGirl.create(:reason) }
  let!(:reason2) {
    FactoryGirl.create(
      :reason,
      reason: "Unexcused Absence",
      student_charged: true,
      teacher_paid: true)
  }

  scenario "marks student present" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"

    expect(page).to have_content("#{lesson1.remaining} lessons remaining")
    within(:css, "#attendance-#{lesson1.student.first_name}-#{lesson1.student.last_name}") do
      expect(page).to have_content(lesson1.active_lesson)
    end

    within(:css, "#attendance-#{lesson1.student.first_name}-#{lesson1.student.last_name}") do
      click_link "Present"
    end

    expect(page).to have_content(lesson1.remaining - 1)
    expect(page).to_not have_content("Present")
    expect(page).to_not have_content("Absent")
  end

  scenario "marks student as excused absence" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"

    within(:css, "#attendance-#{lesson1.student.first_name}-#{lesson1.student.last_name}") do
      click_link "Absent"
      select("#{reason1.reason}", from: "Reason")
      click_button "Submit"
    end

    expect(page).to have_content(lesson1.remaining)
    expect(page).to_not have_content("Present")
    expect(page).to_not have_content("Absent")
  end

  scenario "marks student as unexcused absence" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"

    within(:css, "#attendance-#{lesson1.student.first_name}-#{lesson1.student.last_name}") do
      click_link "Absent"
      select("#{reason2.reason}", from: "Reason")
      click_button "Submit"
    end

    expect(page).to have_content(lesson1.remaining - 1)
    expect(page).to_not have_content("Present")
    expect(page).to_not have_content("Absent")
  end
end
