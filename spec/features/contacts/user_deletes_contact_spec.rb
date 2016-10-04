require "rails_helper"

feature "user deletes contact" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:contact2) { FactoryGirl.create(:contact, first_name: "Tom", email: family1.email, primary: false, family: family1) }
  let!(:family2) { FactoryGirl.create(:family) }
  let!(:contact3) { FactoryGirl.create(:contact, first_name: "Sarah", family: family2) }

  before(:each) do
    sign_in_as(family1)
    click_link "Contacts"
  end
  scenario "successfully deletes contact" do
    within(:css, "#contact-#{contact2.first_name}-#{contact2.last_name}") do
      click_link("delete-contact")
    end

    expect(page).to have_content("Contact Removed")
    expect(page).to_not have_content(contact2.full_name)
  end

  scenario "user attempts to delete another account's student" do
    page.driver.submit :delete, "/contacts/#{contact3.id}", {}

    expect(page).to have_content("You are not authorized to delete this contact")
  end
end
