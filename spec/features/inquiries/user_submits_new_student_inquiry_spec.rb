require "rails_helper"

feature "user submits new student and inquiry" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }

  before(:each) do
    sign_in_as(family1)
  end
  scenario "specifies valid information" do
    click_link "New Student"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    select("Guitar", from: "Instrument")
    find(:css, "#student_form_sunday_checked").set(true)
    find(:css, "#student_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#student_form_sunday_end_time", visible: false).set("7:00 PM")
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Pending Guitar Inquiry")
  end

  scenario "optionally adds notes to inquiry" do
    click_link "New Student"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    select("Guitar", from: "Instrument")
    find(:css, "#student_form_sunday_checked").set(true)
    find(:css, "#student_form_sunday_start_time", visible: false).set("6:00 PM")
    find(:css, "#student_form_sunday_end_time", visible: false).set("7:00 PM")
    fill_in "Additional Notes", with: "Some additional info"
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Pending Guitar Inquiry")
  end

  scenario "does not specify required student information" do
    click_link "New Student"
    click_button "Submit Inquiry"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Pending")
  end

  scenario "does not specify availability" do
    click_link "New Student"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    select("Guitar", from: "Instrument")
    click_button "Submit Inquiry"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Pending")
  end

  scenario "does not specify minimum availability times" do
    click_link "New Student"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Date of Birth", with: "2000/05/13"
    select("Guitar", from: "Instrument")
    find(:css, "#student_form_sunday_checked").set(true)
    find(:css, "#student_form_sunday_start_time", visible: false).set("8:00 PM")
    find(:css, "#student_form_sunday_end_time", visible: false).set("8:25 PM")
    click_button "Submit Inquiry"

    expect(page).to have_content("Availability must be at least 30 minutes")
    expect(page).to have_content("New Student Inquiry")
    expect(page).to_not have_content("Pending")
  end
end
