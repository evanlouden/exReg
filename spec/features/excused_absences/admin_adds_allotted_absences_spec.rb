require "rails_helper"

feature "admin adds allotted excused absences" do
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

  before(:each) do
    sign_in_as(admin1)
    within(:css, ".top-bar-right") do
      click_link("settings-cog")
    end
  end
  scenario "specifies valid information" do
    fill_in "Count", with: "3"
    click_button "Add Count"

    expect(page).to have_content("Count Added")
    expect(page).to have_content("Allotted: 3")
  end

  scenario "does not specify required information" do
    click_button "Add Count"

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("Allotted: 0")
    expect(page).to_not have_content("Count Added")
  end
end
