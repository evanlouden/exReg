require "rails_helper"

feature "admin edits teacher's availability" do
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
  let!(:contact2) { FactoryGirl.create(:contact, teacher: teacher1) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "successfully edits availability" do
    click_link "All Staff"
    click_link "Edit Availability"
    find(:css, "#teacher_availabilities_attributes_1_checked").set(true)
    find(:css, "#teacher_availabilities_attributes_1_start_time", visible: false).set("4:00 PM")
    find(:css, "#teacher_availabilities_attributes_1_end_time", visible: false).set("8:00 PM")
    click_button "Update Availability"

    expect(page).to have_content("Availability Updated")
    expect(page).to have_content("Teachers")
  end

  scenario "does not specify availability" do
    click_link "All Staff"
    click_link "Edit Availability"
    find(:css, "#teacher_availabilities_attributes_0_checked").set(false)
    click_button "Update Availability"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Teachers")
  end

  scenario "selects invalid availability times" do
    click_link "All Staff"
    click_link "Edit Availability"
    find(:css, "#teacher_availabilities_attributes_1_checked").set(true)
    find(:css, "#teacher_availabilities_attributes_1_start_time", visible: false).set("7:00 PM")
    find(:css, "#teacher_availabilities_attributes_1_end_time", visible: false).set("3:00 PM")
    click_button "Update Availability"

    expect(page).to have_content("must be later than start time")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Teachers")
  end

  scenario "does not specify minimum availability times" do
    click_link "All Staff"
    click_link "Edit Availability"
    find(:css, "#teacher_availabilities_attributes_1_checked").set(true)
    find(:css, "#teacher_availabilities_attributes_1_start_time", visible: false).set("7:00 PM")
    find(:css, "#teacher_availabilities_attributes_1_end_time", visible: false).set("7:15 PM")
    click_button "Update Availability"

    expect(page).to have_content("Availability must be at least 30 minutes")
    expect(page).to have_content("Edit Availability")
    expect(page).to_not have_content("Teachers")
  end

  scenario "cancels edit attempt" do
    click_link "All Staff"
    click_link "Edit Availability"
    click_link "Cancel"

    expect(page).to have_content("Teachers")
  end
end
