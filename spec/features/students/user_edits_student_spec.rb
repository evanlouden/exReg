require "rails_helper"

feature "user edits student" do
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
  scenario "successfully edits profile" do
    click_link "Edit Student"
    fill_in "First Name", with: "James"
    fill_in "Date of Birth", with: "2001/05/13"
    click_button "Update Student"

    expect(page).to have_content("Student Updated")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("James Doe")
    expect(page).to_not have_content("John")
  end

  scenario "does not specify required information" do
    click_link "Edit Student"
    fill_in "First Name", with: ""
    click_button "Update Student"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Dashboard")
  end
end
