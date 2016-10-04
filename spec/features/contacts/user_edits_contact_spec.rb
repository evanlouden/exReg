require "rails_helper"

feature "user edits contact" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, family: family1) }

  before(:each) do
    sign_in_as(family1)
    click_link "Contacts"
    click_link("edit-contact")
  end
  scenario "specifies valid information" do
    fill_in "First Name", with: "Jane"
    click_button "Update Contact"

    expect(page).to have_content("Contact Updated")
    expect(page).to have_content("Jane Doe")
  end

  scenario "does not specify valid information" do
    fill_in "First Name", with: ""
    click_button "Update Contact"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Contact Updated")
  end
end
