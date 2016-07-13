require "rails_helper"

feature "user signs up" do
  scenario "specifying valid and required information" do
    visit unauthenticated_root_path
    click_link "Sign Up"
    within(:css, "#account-email") do
      fill_in "Email", with: "user99@user.com"
    end
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    fill_in "Address", with: "100 Main Street"
    fill_in "City", with: "Boston"
    select("Massachusetts", from: "State")
    fill_in "Zip", with: "02115"
    fill_in "First Name", with: "Jimmy"
    fill_in "Last Name", with: "Smith"
    within(:css, ".accounts-contacts") do
      fill_in "Email", with: "jsmith@example.com"
    end
    fill_in "Phone", with: "9785551212"
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

  scenario "does not specify valid zip code" do
    visit unauthenticated_root_path
    click_link "Sign Up"
    within(:css, "#account-email") do
      fill_in "Email", with: "user99@user.com"
    end
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    fill_in "Address", with: "100 Main Street"
    fill_in "City", with: "Boston"
    select("Massachusetts", from: "State")
    fill_in "Zip", with: "abc"
    fill_in "First Name", with: "Jimmy"
    fill_in "Last Name", with: "Smith"
    within(:css, ".accounts-contacts") do
      fill_in "Email", with: "jsmith@example.com"
    end
    fill_in "Phone", with: "9785551212"
    click_button "Sign Up"

    expect(page).to have_content("Zip is not a number")
    expect(page).to have_content("Zip is the wrong length")
    expect(page).to_not have_content("Sign Out")
  end
end
