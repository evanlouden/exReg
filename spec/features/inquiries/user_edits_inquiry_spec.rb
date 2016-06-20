require "rails_helper"

feature "user edits student inquiry" do
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
  scenario "existing user successfully edits inquiry form" do
    visit dashboard_index_path
    click_link "Edit Inquiry"
    fill_in "Instrument", with: "Piano"
    within(:css, "#Sunday") do
      fill_in "Start", with: "5:00 PM"
    end
    click_button "Update Inquiry"

    expect(page).to have_content("Inquiry Updated")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("#{student1.first_name} #{student1.last_name} - Piano")
  end

  scenario "existing user does not specify required information" do
    visit dashboard_index_path
    click_link "Edit Inquiry"
    fill_in "First Name", with: ""
    click_button "Update Inquiry"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("Edit Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "existing user selects invalid availability times" do
    visit dashboard_index_path
    click_link "Edit Inquiry"
    within(:css, "#Sunday") do
      fill_in "Start", with: "11:00 PM"
    end
    click_button "Update Inquiry"

    expect(page).to have_content("must be later than start time")
    expect(page).to have_content("Edit Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end

  scenario "existing user does not specify availability" do
    visit dashboard_index_path
    click_link "Edit Inquiry"
    find(:css, "#student_inquiries_attributes_0_availabilities_attributes_0_checked").set(false)
    click_button "Update Inquiry"

    expect(page).to have_content("Please select at least one day of availability")
    expect(page).to have_content("Student Inquiry")
    expect(page).to_not have_content("Dashboard")
  end
end
