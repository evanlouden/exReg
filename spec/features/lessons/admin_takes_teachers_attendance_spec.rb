require "rails_helper"

feature "admin takes teacher's attendance", js: true do
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
  let!(:teacher2) { FactoryGirl.create(:teacher) }
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
      teacher: teacher2,
      inquiry: inquiry1,
      start_date: Date.today.strftime("%F"),
      day: Date.today.strftime("%A")
    )
  }
  let!(:contact2) { FactoryGirl.create(:contact, teacher: teacher1) }
  let!(:contact3) {
    FactoryGirl.create(
      :contact,
      teacher: teacher2,
      first_name: "John",
      last_name: "Doe"
    )
  }
  let!(:reason1) { FactoryGirl.create(:reason) }
  let!(:reason2) {
    FactoryGirl.create(
      :reason,
      reason: "Unexcused Absence",
      student_charged: true,
      teacher_paid: true)
  }

  before(:each) do
    sign_in_as(admin1)
  end
  scenario "marks student present" do
    within(:css, "#admin-attendance") do
      find("option[value='#{teacher2.id}']").click
    end
    within(:css, "#attendance-#{lesson1.student.first_name}-#{lesson1.student.last_name}") do
      click_link "Present"
    end

    expect(page).to_not have_content("Present")
    expect(page).to_not have_content("Absent")
  end

  scenario "marks student as excused absence" do
    within(:css, "#admin-attendance") do
      find("option[value='#{teacher2.id}']").click
    end
    within(:css, "#attendance-#{lesson1.student.first_name}-#{lesson1.student.last_name}") do
      click_link "Absent"
      select(reason1.reason, from: "Reason")
      click_button "Submit"
    end

    expect(page).to_not have_content("Present")
    expect(page).to_not have_content("Absent")

    click_link "Lessons"

    expect(page).to have_content(lesson1.excused_remaining - 1)
  end

  scenario "marks student as unexcused absence" do
    within(:css, "#admin-attendance") do
      find("option[value='#{teacher2.id}']").click
    end
    within(:css, "#attendance-#{lesson1.student.first_name}-#{lesson1.student.last_name}") do
      click_link "Absent"
      select(reason2.reason, from: "Reason")
      click_button "Submit"
    end

    expect(page).to_not have_content("Present")
    expect(page).to_not have_content("Absent")
  end
end
