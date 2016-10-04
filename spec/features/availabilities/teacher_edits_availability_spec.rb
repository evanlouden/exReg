require "rails_helper"

feature "teacher edits availability" do
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact1) { FactoryGirl.create(:contact, teacher: teacher1) }

  before(:each) do
    sign_in_as(teacher1)
    click_link "Edit Availability"
  end
  scenario "successfully edits availability" do
    find(:css, "#teacher_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#teacher_form_sunday_end_time", visible: false).set("7:00 PM")
    find(:css, "#teacher_form_monday_checked").set(false)
    click_button "Update Availability"

    expect(page).to have_content("Availability Updated")
    expect(page).to_not have_content("Update Availability")
  end

  scenario "does not specify availability" do
    find(:css, "#teacher_form_sunday_checked").set(false)
    find(:css, "#teacher_form_monday_checked").set(false)
    click_button "Update Availability"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Current Lessons")
  end

  scenario "does not specify minimum availability times" do
    find(:css, "#teacher_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#teacher_form_sunday_end_time", visible: false).set("6:15 PM")
    find(:css, "#teacher_form_monday_checked").set(false)
    click_button "Update Availability"

    expect(page).to have_content("Availability must be at least 30 minutes")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Current Lessons")
  end
end
