require "rails_helper"

feature "user signs out" do
  scenario "logged in user successfully signs out" do
    family1 = FactoryGirl.create(:family)
    FactoryGirl.create(:contact, email: family1.email, family: family1)
    sign_in_as(family1)
    click_link "Sign Out"

    expect(page).to have_content("See You Again Soon!")
    expect(page).to_not have_content("Sign Out")
  end
end
