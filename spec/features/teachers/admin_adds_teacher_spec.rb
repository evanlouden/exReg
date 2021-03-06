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
    sign_in_as(admin1)
  end
  scenario "specifies valid account information" do
    click_link "Add Teacher"
    fill_in "Email", with: "newteacher@teacher.com"
    fill_in "Address", with: "100 Main Street"
    fill_in "City", with: "Boston"
    select("Massachusetts", from: "State")
    fill_in "Zip", with: "01886"
    fill_in "First Name", with: "Thomas"
    fill_in "Last Name", with: "Appleseed"
    fill_in "Phone", with: "9785551212"
    find(:css, "#teacher_form_sunday_checked").set(true)
    find(:css, "#teacher_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#teacher_form_sunday_end_time", visible: false).set("7:00 PM")
    click_button "Create Account"

    expect(page).to have_content("Account created")
    expect(page).to have_content("Attendance")

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
    find(:css, "#teacher_form_sunday_checked").set(true)
    find(:css, "#teacher_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#teacher_form_sunday_end_time", visible: false).set("7:00 PM")
    click_button "Create Account"

    expect(page).to have_content("New Teacher Account")
    expect(page).to have_content("Zip is not a number")
    expect(page).to have_content("Zip is the wrong length")
    expect(page).to_not have_content("Account created")
  end

  scenario "does not specify valid city" do
    click_link "Add Teacher"
    fill_in "Email", with: "newteacher@teacher.com"
    fill_in "Address", with: "100 Main Street"
    fill_in "City", with: "6565"
    select("Massachusetts", from: "State")
    fill_in "Zip", with: "01886"
    fill_in "First Name", with: "Thomas"
    fill_in "Last Name", with: "Appleseed"
    fill_in "Phone", with: "9785551212"
    find(:css, "#teacher_form_sunday_checked").set(true)
    find(:css, "#teacher_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#teacher_form_sunday_end_time", visible: false).set("7:00 PM")
    click_button "Create Account"

    expect(page).to have_content("New Teacher Account")
    expect(page).to have_content("can only be letters")
    expect(page).to_not have_content("Account created")
  end
end
