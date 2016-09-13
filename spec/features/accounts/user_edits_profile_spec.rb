require "rails_helper"

feature "user edits profile" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    click_link("profile-icon")
  end
  scenario "successfully edits profile" do
    select("Alaska", from: "State")
    fill_in "Current Password", with: family1.password
    click_button "Update"

    expect(page).to have_content("Account Updated")
    expect(page).to have_content("Sign Out")
  end

  scenario "does not specify valid information" do
    fill_in "Zip", with: ""
    fill_in "Current Password", with: family1.password
    click_button "Update"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Account Updated")
  end
end
