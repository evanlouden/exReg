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
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    within(:css, ".top-bar-right") do
      click_link("settings-cog")
    end
    click_link("delete-reason")

    expect(page).to have_content("Reason Removed")
  end
end
