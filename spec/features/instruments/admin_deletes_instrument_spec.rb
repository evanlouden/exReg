require "rails_helper"

feature "admin deletes instrument" do
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
  let!(:instrument1) { FactoryGirl.create(:instrument) }

  scenario "successfully deletes instrument" do
    sign_in_as(admin1)
    within(:css, ".top-bar-right") do
      click_link("settings-cog")
    end
    click_link("delete-instrument")

    expect(page).to have_content("Instrument Removed")
  end
end
