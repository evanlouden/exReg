require "rails_helper"

feature "admin deletes absence reason" do
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
  let!(:reason1) { FactoryGirl.create(:reason) }

  scenario "successfully deletes reason" do
    sign_in_as(admin1)
    within(:css, ".top-bar-right") do
      click_link("settings-cog")
    end
    click_link("delete-reason")

    expect(page).to have_content("Reason Removed")
  end
end
