require "rails_helper"

feature "user adds contact" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }

  before(:each) do
    sign_in_as(family1)
    click_link "Contacts"
    click_link("add-contact")
  end
  scenario "specifies valid information" do
    fill_in "First Name", with: "Grandma"
    fill_in "Last Name", with: "Doe"
    fill_in "Email", with: "grandmadoe@user.com"
    fill_in "Phone", with: "9785551212"
    click_button "Add Contact"

    expect(page).to have_content("Contact Added")
    expect(page).to have_content("Grandma Doe")
  end

  scenario "does not specify valid information" do
    click_button "Add Contact"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Contact Added")
  end
end
