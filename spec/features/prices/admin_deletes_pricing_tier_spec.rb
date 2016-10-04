require "rails_helper"

feature "admin deletes pricing tier" do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:contact1) {
    FactoryGirl.create(
      :contact,
      admin: admin1,
      email: admin1.email,
      first_name: "Bernie",
      last_name: "Sanders"
    )
  }
  let!(:price1) { FactoryGirl.create(:price) }

  scenario "successfully deletes contact" do
    sign_in_as(admin1)
    within(:css, ".top-bar-right") do
      click_link("settings-cog")
    end
    click_link("delete-price")

    expect(page).to have_content("Pricing Tier Removed")
  end
end
