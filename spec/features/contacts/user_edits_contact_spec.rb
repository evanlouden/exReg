require "rails_helper"

feature "user edits contact" do
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:contact1) { FactoryGirl.create(:contact, account: user1) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "specifies valid information" do
    click_link "Edit Contact"
    fill_in "First Name", with: "Jane"
    click_button "Update Contact"

    expect(page).to have_content("Contact Updated")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Jane Doe")
  end

  scenario "does not specify valid information" do
    click_link "Edit Contact"
    fill_in "First Name", with: ""
    click_button "Update Contact"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Dashboard")
  end
end
