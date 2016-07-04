require "rails_helper"

feature "user edits student" do
  let!(:user1) { FactoryGirl.create(:family) }
  let!(:student1) { FactoryGirl.create(:student, family: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "successfully edits availability" do
    click_link "Edit Student Availability"
    find(:css, "#student_availabilities_attributes_0_start_time", visible: false).set("6:00 PM")
    find(:css, "#student_availabilities_attributes_0_end_time", visible: false).set("7:00 PM")
    click_button "Update Availability"

    expect(page).to have_content("Availability Updated")
    expect(page).to have_content("Dashboard")
  end

  scenario "does not specify availability" do
    click_link "Edit Student Availability"
    find(:css, "#student_availabilities_attributes_0_checked").set(false)
    click_button "Update Availability"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "selects invalid availability times" do
    click_link "Edit Student Availability"
    find(:css, "#student_availabilities_attributes_1_checked").set(true)
    find(:css, "#student_availabilities_attributes_1_start_time", visible: false).set("9:00 PM")
    find(:css, "#student_availabilities_attributes_1_end_time", visible: false).set("4:00 PM")
    click_button "Update Availability"

    expect(page).to have_content("must be later than start time")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "does not specify minimum availability times" do
    click_link "Edit Student Availability"
    find(:css, "#student_availabilities_attributes_1_checked").set(true)
    find(:css, "#student_availabilities_attributes_1_start_time", visible: false).set("5:00 PM")
    find(:css, "#student_availabilities_attributes_1_end_time", visible: false).set("5:10 PM")
    click_button "Update Availability"

    expect(page).to have_content("Availability must be at least 30 minutes")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Dashboard")
  end
end
