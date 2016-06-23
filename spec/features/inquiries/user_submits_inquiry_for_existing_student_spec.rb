require "rails_helper"

feature "user submits new student inquiry" do
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "existing user specifies valid information" do
    click_link "New Inquiry for #{student1.first_name}"
    fill_in "Instrument", with: "Piano"
    find(:css, "#inquiry_availabilities_attributes_0_checked").set(true)
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
    expect(page).to have_content("Instrument: Piano")
  end

  scenario "existing user optionally adds notes to inquiry" do
    click_link "New Inquiry for #{student1.first_name}"
    fill_in "Instrument", with: "Piano"
    find(:css, "#inquiry_availabilities_attributes_0_checked").set(true)
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
    expect(page).to have_content("Instrument: Piano")
  end

  scenario "existing user does not specify required inquiry information" do
    click_link "New Inquiry for #{student1.first_name}"
    click_button "Submit Inquiry"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "existing user does not specify availability" do
    click_link "New Inquiry for #{student1.first_name}"
    fill_in "Instrument", with: "Piano"
    click_button "Submit Inquiry"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "existing user does not specify availability times" do
    click_link "New Inquiry for #{student1.first_name}"
    fill_in "Instrument", with: "Piano"
    find(:css, "#inquiry_availabilities_attributes_0_checked").set(true)
    click_button "Submit Inquiry"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "existing user selects invalid availability times" do
    click_link "New Inquiry for #{student1.first_name}"
    fill_in "Instrument", with: "Piano"
    find(:css, "#inquiry_availabilities_attributes_0_checked").set(true)
    within(:css, "#Sunday") do
      fill_in "Start", with: "6:00 PM"
    end
    within(:css, "#Sunday") do
      fill_in "End", with: "3:00 PM"
    end
    click_button "Submit Inquiry"

    expect(page).to have_content("must be later than start time")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "existing user does not specify minimum availability times" do
    click_link "New Inquiry for #{student1.first_name}"
    fill_in "Instrument", with: "Piano"
    find(:css, "#inquiry_availabilities_attributes_0_checked").set(true)
    within(:css, "#Sunday") do
      fill_in "Start", with: "6:00 PM"
    end
    within(:css, "#Sunday") do
      fill_in "End", with: "6:25 PM"
    end
    click_button "Submit Inquiry"

    expect(page).to have_content("Availability must be at least 30 minutes")
    expect(page).to_not have_content("Dashboard")
  end
end
