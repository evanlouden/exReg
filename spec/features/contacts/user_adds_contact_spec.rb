require "rails_helper"

feature "user adds contact" do
  let!(:user1) { FactoryGirl.create(:family) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "specifies valid information" do
    click_link "Add Contact"
    fill_in "First Name", with: "Grandma"
    fill_in "Last Name", with: "Doe"
    fill_in "Email", with: "grandmadoe@user.com"
    fill_in "Phone", with: "9785551212"
    click_button "Add Contact"

    expect(page).to have_content("Contact Added")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Grandma Doe")
    expect(page).to_not have_content("Grandma Doe - Primary")
  end

  scenario "does not specify valid information" do
    click_link "Add Contact"
    click_button "Add Contact"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Dashboard")
  end
end
