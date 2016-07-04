require "rails_helper"

feature "user deletes contact" do
  let!(:user1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, family: user1) }
  let!(:user2) { FactoryGirl.create(:family) }
  let!(:contact2) { FactoryGirl.create(:contact, first_name: "Sarah", family: user2) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "successfully deletes contact" do
    click_link "Delete Contact"

    expect(page).to have_content("Contact Removed")
    expect(page).to have_content("Dashboard")
    expect(page).to_not have_content("Sandra Doe")
  end

  scenario "user attempts to delete another account's student" do
    page.driver.submit :delete, "/contacts/#{contact2.id}", {}

    expect(page).to have_content("You are not authorized to delete this contact")
  end
end
