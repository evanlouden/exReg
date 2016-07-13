require "rails_helper"

feature "user edits profile" do
  let!(:user1) { FactoryGirl.create(:family) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "successfully edits profile" do
    click_link "Profile"
    select("Alaska", from: "State")
    fill_in "Current Password", with: user1.password
    click_button "Update"

    expect(page).to have_content("Account Updated")
    expect(page).to have_content("Sign Out")
  end

  scenario "does not specify valid information" do
    click_link "Profile"
    fill_in "Zip", with: ""
    fill_in "Current Password", with: user1.password
    click_button "Update"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Account Updated")
  end
end
