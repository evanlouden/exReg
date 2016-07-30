require "rails_helper"

feature "admin edits teacher's lessons", js: true do
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

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "successfully edits teacher's lessons" do
    within(:css, "#teacher-cal-dropdown") do
      find("option[value='#{teacher1.id}']").click
    end
    within(:css, "##{lesson1.day}-0800PM") do
      find(:xpath, ".//div[@id='lesson-#{lesson1.day}-0800PM']")
    end
    lesson_element = find("#lesson-#{lesson1.day}-0800PM")
    new_lesson_block = find("#Sunday-0730PM")
    lesson_element.drag_to new_lesson_block

    expect(page).to have_content("Save")

    click_link "Save"

    within(:css, "##{lesson1.day}-0730PM") do
      find(:xpath, ".//div[@id='lesson-#{lesson1.day}-0730PM']")
    end
  end

  scenario "reverts edits" do
    within(:css, "#teacher-cal-dropdown") do
      find("option[value='#{teacher1.id}']").click
    end
    lesson_element = find("#lesson-#{lesson1.day}-0800PM")
    new_lesson_block = find("#Sunday-0730PM")
    lesson_element.drag_to new_lesson_block
    click_link "Revert"

    within(:css, "##{lesson1.day}-0800PM") do
      find(:xpath, ".//div[@id='lesson-#{lesson1.day}-0800PM']")
    end
    expect(page).to_not have_content("Save")
    expect(page).to_not have_content("Revert")
  end
end
