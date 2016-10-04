require "rails_helper"

feature "user changes primary contact" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:contact2) { FactoryGirl.create(:contact, first_name: "John", email: "johndoe@family.com", primary: false, family: family1) }

  scenario "successfully changes primary contact" do
    sign_in_as(family1)
    click_link "Contacts"
    click_link "Make Primary"

    within(:css, "#contact-#{contact2.first_name}-#{contact2.last_name}") do
      expect(page).to have_css(".fa-star")
    end

    within(:css, "#contact-#{contact1.first_name}-#{contact1.last_name}") do
      expect(page).to_not have_css(".fa-star")
    end
  end
end
