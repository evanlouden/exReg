require "rails_helper"

feature "user edits student availability" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }

  before(:each) do
    sign_in_as(family1)
    click_link student1.full_name
    click_link("edit-availability")
  end
  scenario "successfully edits availability" do
    find(:css, "#student_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#student_form_sunday_end_time", visible: false).set("7:00 PM")
    click_button "Update Availability"

    expect(page).to have_content("Availability Updated")
    expect(page).to have_content(student1.full_name)
  end

  scenario "does not specify availability" do
    find(:css, "#student_form_sunday_checked").set(false)
    click_button "Update Availability"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Pending")
  end

  scenario "does not specify minimum availability times" do
    find(:css, "#student_form_monday_checked").set(true)
    find(:css, "#student_form_monday_start_time", visible: false).set("5:00 PM")
    find(:css, "#student_form_monday_end_time", visible: false).set("5:10 PM")
    click_button "Update Availability"

    expect(page).to have_content("Availability must be at least 30 minutes")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Pending")
  end
end
