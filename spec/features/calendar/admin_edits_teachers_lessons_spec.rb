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
  let!(:student2) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry2) {
    FactoryGirl.create(
      :inquiry,
      student: student2,
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
  let!(:lesson2) {
    FactoryGirl.create(
      :lesson,
      day: "Monday",
      student: student2,
      teacher: teacher1,
      inquiry: inquiry2
    )
  }

  before(:each) do
    sign_in_as(admin1)
  end
  scenario "successfully edits teacher's lessons" do
    within(:css, "#teacher-cal-dropdown") do
      find("option[value='#{teacher1.id}']").click
    end

    using_wait_time 15 do
      within(:css, "##{lesson1.day}-0800PM") do
        find(:xpath, ".//div[@id='lesson-#{lesson1.day}-0800PM']")
      end
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

  scenario "places lesson hanging over unavailable block" do
    within(:css, "#teacher-cal-dropdown") do
      find("option[value='#{teacher1.id}']").click
    end
    lesson_element = find("#lesson-#{lesson1.day}-0800PM")
    new_lesson_block = find("#Sunday-1000PM")
    lesson_element.drag_to new_lesson_block

    within(:css, "##{lesson1.day}-0800PM") do
      find(:xpath, ".//div[@id='lesson-#{lesson1.day}-0800PM']")
    end
  end

  scenario "places lesson on top of another lesson" do
    within(:css, "#teacher-cal-dropdown") do
      find("option[value='#{teacher1.id}']").click
    end
    lesson_element = find("#lesson-#{lesson1.day}-0800PM")
    new_lesson_block = find("#Monday-0800PM")
    lesson_element.drag_to new_lesson_block

    within(:css, "##{lesson1.day}-0800PM") do
      find(:xpath, ".//div[@id='lesson-#{lesson1.day}-0800PM']")
    end
  end
end
