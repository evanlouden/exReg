require "rails_helper"

feature "admin signs up teacher" do
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

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "specifies valid account information" do
    click_link "Add Teacher"
    fill_in "Email", with: "newteacher@teacher.com"
    fill_in "Address", with: "100 Main Street"
    fill_in "City", with: "Boston"
    select("Massachusetts", from: "State")
    fill_in "Zip", with: "02115"
    fill_in "First Name", with: "Thomas"
    fill_in "Last Name", with: "Appleseed"
    fill_in "Phone", with: "9785551212"
    find(:css, "#teacher_availabilities_attributes_0_checked").set(true)
    find(:css, "#teacher_availabilities_attributes_0_start_time", visible: false).set("6:00 PM")
    find(:css, "#teacher_availabilities_attributes_0_end_time", visible: false).set("7:00 PM")
    click_button "Create Account"

    expect(page).to have_content("Account created")
    expect(page).to have_content("Admin Dashboard")

    click_link "All Staff"

    expect(page).to have_content("Thomas Appleseed")
  end

  scenario "does not specify valid account information" do
    click_link "Add Teacher"
    click_button "Create Account"

    expect(page).to have_content("New Teacher Account")
    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Admin Dashboard")
  end

  scenario "does not specify valid zip code" do
    click_link "Add Teacher"
    fill_in "Email", with: "newteacher@teacher.com"
    fill_in "Address", with: "100 Main Street"
    fill_in "City", with: "Boston"
    select("Massachusetts", from: "State")
    fill_in "Zip", with: "abc"
    fill_in "First Name", with: "Thomas"
    fill_in "Last Name", with: "Appleseed"
    fill_in "Phone", with: "9785551212"
    find(:css, "#teacher_availabilities_attributes_0_checked").set(true)
    find(:css, "#teacher_availabilities_attributes_0_start_time", visible: false).set("6:00 PM")
    find(:css, "#teacher_availabilities_attributes_0_end_time", visible: false).set("7:00 PM")
    click_button "Create Account"

    expect(page).to have_content("New Teacher Account")
    expect(page).to have_content("Zip is not a number")
    expect(page).to have_content("Zip is the wrong length")
    expect(page).to_not have_content("Admin Dashboard")
  end
end
