require "rails_helper"

feature "admin edits instrument" do
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

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    within(:css, ".top-bar-right") do
      click_link("settings-cog")
    end
    click_link("edit-instrument")
  end
  scenario "specifies valid information" do
    fill_in "Instrument Name", with: "Piano"
    click_button "Update Instrument"

    expect(page).to have_content("Instrument Updated")
    expect(page).to have_content("Piano")
    expect(page).to_not have_content("Guitar")
  end

  scenario "does not specify required information" do
    fill_in "Instrument Name", with: ""
    click_button "Update Instrument"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Instrument Updated")
    expect(page).to_not have_content("School Settings")
  end
end
