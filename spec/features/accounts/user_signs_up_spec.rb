require "rails_helper"

feature "user signs up" do
  scenario "specifying valid and required information" do
    visit unauthenticated_root_path
    click_link "Sign Up"
    fill_in "Email", with: "user99@user.com"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    fill_in "Address", with: "100 Main Street"
    fill_in "City", with: "Boston"
    fill_in "State", with: "MA"
    fill_in "Zip", with: "02115"
    click_button "Sign Up"

    expect(page).to have_content("Account Created!")
    expect(page).to have_content("Sign Out")
    expect(page).to have_content("Student Inquiry")
  end

  scenario "required account information not specified" do
    visit unauthenticated_root_path
    click_link "Sign Up"
    click_button "Sign Up"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Sign Out")
  end

  scenario "password confirmation does not match confirmation" do
    visit unauthenticated_root_path
    click_link "Sign Up"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "wrongpassword"
    click_button "Sign Up"

    expect(page).to have_content("doesn't match")
    expect(page).to_not have_content("Sign Out")
  end
end