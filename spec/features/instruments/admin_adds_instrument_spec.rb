require "rails_helper"

feature "admin adds instrument" do
  let!(:admin1) { FactoryGirl.create(:admin) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "specifies valid information" do
    click_link "Instruments"
    fill_in "Name", with: "Guitar"
    click_button "Add Instrument"

    expect(page).to have_content("Instrument Added")
    expect(page).to have_content("Guitar")
  end

  scenario "does not specify required information" do
    click_link "Instruments"
    click_button "Add Instrument"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Instrument Added")
  end
end
