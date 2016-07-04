require "rails_helper"

feature "admin deletes pricing tier" do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:price1) { FactoryGirl.create(:price) }

  scenario "successfully deletes contact" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link "Pricing Tiers"
    click_link "Delete"

    expect(page).to have_content("Pricing Tier Removed")
  end
end
