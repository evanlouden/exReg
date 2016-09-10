require "rails_helper"

feature "admin edits allotted excused absences" do
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
  let!(:count1) { FactoryGirl.create(:excused_absence) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link("settings-cog")
  end
  scenario "specifies valid information" do
    fill_in "Count", with: "5"
    click_button "Update Count"

    expect(page).to have_content("Count Updated")
    expect(page).to have_content("Allotted: 5")
  end

  scenario "does not specify required information" do
    fill_in "Count", with: ""
    click_button "Update Count"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content(count1.count)
    expect(page).to_not have_content("Count Added")
  end
end
