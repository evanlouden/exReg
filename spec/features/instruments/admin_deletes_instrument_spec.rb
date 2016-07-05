require "rails_helper"

feature "admin deletes instrument" do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }

  scenario "successfully deletes instrument" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link "Instruments"
    click_link "Delete"

    expect(page).to have_content("Instrument Removed")
  end
end
