require "rails_helper"

feature "user changes primary contact" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:contact2) { FactoryGirl.create(:contact, first_name: "John", email: "johndoe@family.com", primary: false, family: family1) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
  end
  scenario "successfully changes primary contact" do
    click_link "Contacts"
    click_link "Make Primary"

    expect(page).to have_content("#{contact2.full_name} - Primary")
    expect(page).to_not have_content("#{contact1.full_name} - Primary")
  end

  scenario "deletes primary contact" do
    click_link "Contacts"
    within(:css, "#contact-#{contact1.first_name}-#{contact1.last_name}") do
      click_link "Delete Contact"
    end

    expect(page).to have_content("#{contact2.full_name} - Primary")
    expect(page).to_not have_content("#{contact1.full_name} - Make Primary")
  end
end
