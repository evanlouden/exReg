require "rails_helper"

feature "user signs in" do
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:admin1) { FactoryGirl.create(:account, admin: true) }
  scenario "existing user specifies valid email and password" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"

    expect(page).to have_content("Welcome Back!")
    expect(page).to have_content("Sign Out")
    expect(page).to have_content("Dashboard")
  end

  scenario "existing admin specifies valid email and password" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"

    expect(page).to have_content("Welcome Back!")
    expect(page).to have_content("Admin Dashboard")
    expect(page).to have_content("Staff Members")
  end

  scenario "nonexistent email and password supplied" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: "some_email@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    expect(page).to have_content("Invalid email or password")
    expect(page).to_not have_content("Welcome Back!")
    expect(page).to_not have_content("Sign Out")
  end

  scenario "an existing email with wrong password is denied access" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: "wrongpassword"
    click_button "Sign In"

    expect(page).to have_content("Invalid email or password")
    expect(page).to_not have_content("Welcome Back!")
    expect(page).to_not have_content("Sign Out")
  end

  scenario "authenticated user cannot re-sign in" do
    visit new_account_session_path
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"

    expect(page).to have_content("Sign Out")
    expect(page).to_not have_content("Sign In")

    visit new_account_session_path

    expect(page).to have_content("You Are Already Signed In!")
  end
end
