require "rails_helper"

feature "user submits new student and inquiry" do
  let!(:user1) { FactoryGirl.create(:account) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "specifies valid information" do
    click_link "New Student & Inquiry"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    fill_in "Instrument", with: "Guitar"
    find(:css, "#student_inquiries_attributes_0_availabilities_attributes_0_checked").set(true)
    within(:css, "#Sunday") do
      fill_in "Start", with: "6:00 PM"
    end
    within(:css, "#Sunday") do
      fill_in "End", with: "7:00 PM"
    end
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Instrument: Guitar")
  end

  scenario "optionally adds notes to inquiry" do
    click_link "New Student & Inquiry"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    fill_in "Instrument", with: "Guitar"
    find(:css, "#student_inquiries_attributes_0_availabilities_attributes_0_checked").set(true)
    within(:css, "#Sunday") do
      fill_in "Start", with: "6:00 PM"
    end
    within(:css, "#Sunday") do
      fill_in "End", with: "7:00 PM"
    end
    fill_in "Additional Notes", with: "Some additional info"
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Instrument: Guitar")
  end

  scenario "does not specify required student information" do
    click_link "New Student & Inquiry"
    click_button "Submit Inquiry"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "does not specify availability" do
    click_link "New Student & Inquiry"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    fill_in "Instrument", with: "Guitar"
    click_button "Submit Inquiry"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "does not specify availability times" do
    click_link "New Student & Inquiry"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    fill_in "Instrument", with: "Guitar"
    find(:css, "#student_inquiries_attributes_0_availabilities_attributes_0_checked").set(true)
    click_button "Submit Inquiry"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "selects invalid availability times" do
    click_link "New Student & Inquiry"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    fill_in "Instrument", with: "Guitar"
    find(:css, "#student_inquiries_attributes_0_availabilities_attributes_0_checked").set(true)
    within(:css, "#Sunday") do
      fill_in "Start", with: "9:00 PM"
    end
    within(:css, "#Sunday") do
      fill_in "End", with: "4:00 PM"
    end
    click_button "Submit Inquiry"

    expect(page).to have_content("must be later than start time")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "does not specify minimum availability times" do
    click_link "New Student & Inquiry"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    fill_in "Instrument", with: "Guitar"
    find(:css, "#student_inquiries_attributes_0_availabilities_attributes_0_checked").set(true)
    within(:css, "#Sunday") do
      fill_in "Start", with: "8:00 PM"
    end
    within(:css, "#Sunday") do
      fill_in "End", with: "8:25 PM"
    end
    click_button "Submit Inquiry"

    expect(page).to have_content("Availability must be at least 30 minutes")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end
end
