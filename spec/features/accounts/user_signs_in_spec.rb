require "rails_helper"

feature "user signs in" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }

  scenario "existing user specifies valid email and password" do
    sign_in_as(family1)

    expect(page).to have_content("Welcome Back!")
    expect(page).to have_content("Sign Out")
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
    fill_in "Email", with: family1.email
    fill_in "Password", with: "wrongpassword"
    click_button "Sign In"

    expect(page).to have_content("Invalid email or password")
    expect(page).to_not have_content("Welcome Back!")
    expect(page).to_not have_content("Sign Out")
  end

  scenario "authenticated user cannot re-sign in" do
    visit new_account_session_path
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"

    expect(page).to have_content("Sign Out")
    expect(page).to_not have_content("Sign In")

    visit new_account_session_path

    expect(page).to have_content("You Are Already Signed In!")
  end

  scenario "authenticated user cannot sign in to admin dash" do
    visit new_account_session_path
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    visit admin_index_path

    expect(page).to have_content("You do not have permission to access this page")
  end
end
