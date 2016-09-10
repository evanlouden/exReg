require "rails_helper"

feature "admin edits absence reason" do
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

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link("settings-cog")
  end
  scenario "specifies valid information" do
    expect(page).to have_content(reason1.reason)

    click_link "Edit"
    fill_in "Reason Name", with: "Unexcused Absence"
    click_button "Update Reason"

    expect(page).to have_content("Reason Updated")
    expect(page).to have_content("Unexcused Absence")
  end

  scenario "does not specify required information" do
    click_link "Edit"
    fill_in "Reason Name", with: ""
    click_button "Update Reason"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Reason Updated")
    expect(page).to_not have_content("School Settings")
  end
end
