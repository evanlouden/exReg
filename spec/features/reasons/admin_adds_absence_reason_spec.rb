require "rails_helper"

feature "admin adds absence reason" do
  let!(:admin1) { FactoryGirl.create(:admin) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "specifies valid information" do
    click_link "Absence Reasons"
    fill_in "Reason Name", with: "Unexcused Absence"
    select("Yes", from: "Teacher Paid?")
    select("Yes", from: "Charge Student?")
    click_button "Add Reason"

    expect(page).to have_content("Reason Added")
    expect(page).to have_content("Unexcused Absence")
  end

  scenario "does not specify required information" do
    click_link "Absence Reasons"
    click_button "Add Reason"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Reason Added")
  end
end
