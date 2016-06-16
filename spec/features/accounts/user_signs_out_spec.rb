require "rails_helper"

feature "user signs out" do
  scenario "logged in user successfully signs out" do
    user1 = FactoryGirl.create(:account)
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
    click_link "Sign Out"

    expect(page).to have_content("See You Again Soon!")
    expect(page).to_not have_content("Sign Out")
  end
end