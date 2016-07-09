require "rails_helper"

feature "admin deletes absence reason" do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:reason1) { FactoryGirl.create(:reason) }

  scenario "successfully deletes reason" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link "Absence Reasons"
    click_link "Delete"

    expect(page).to have_content("Reason Removed")
  end
end
