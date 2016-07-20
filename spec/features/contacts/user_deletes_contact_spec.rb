require "rails_helper"

feature "user deletes contact" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:contact2) { FactoryGirl.create(:contact, first_name: "Tom", email: family1.email, family: family1) }
  let!(:family2) { FactoryGirl.create(:family) }
  let!(:contact3) { FactoryGirl.create(:contact, first_name: "Sarah", family: family2) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
  end
  scenario "successfully deletes contact" do
    click_link "Contacts"
    within(:css, "#contact-#{contact2.first_name}-#{contact2.last_name}") do
      click_link "Delete Contact"
    end

    expect(page).to have_content("Contact Removed")
    expect(page).to have_content("Dashboard")
    expect(page).to_not have_content(contact2.full_name)
  end

  scenario "user attempts to delete another account's student" do
    page.driver.submit :delete, "/contacts/#{contact3.id}", {}

    expect(page).to have_content("You are not authorized to delete this contact")
  end
end
