require "rails_helper"

feature "user submits new student inquiry" do
  let!(:user1) { FactoryGirl.create(:account) }
  scenario "existing user specifies valid information" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
    click_link "New Inquiry"

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
    fill_in "Notes", with: "Some additional info"
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("John Doe - Guitar")
  end
end
