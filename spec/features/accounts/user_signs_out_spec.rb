require "rails_helper"

feature "user signs out" do
  scenario "logged in user successfully signs out" do
    family1 = FactoryGirl.create(:family)
    contact1 = FactoryGirl.create(:contact, email: family1.email, family: family1)
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    click_link "Sign Out"

    expect(page).to have_content("See You Again Soon!")
    expect(page).to_not have_content("Sign Out")
  end
end
