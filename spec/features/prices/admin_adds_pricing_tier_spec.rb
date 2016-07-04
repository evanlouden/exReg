require "rails_helper"

feature "admin adds pricing tier" do
  let!(:admin1) { FactoryGirl.create(:admin) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "specifies valid information" do
    click_link "Pricing Tiers"
    fill_in "Tier Name", with: "Private Lesson"
    fill_in "Duration (minutes)", with: "30"
    fill_in "Price", with: "50"
    click_button "Create Pricing Tier"

    expect(page).to have_content("Pricing Tier Added")
    expect(page).to have_content("Private Lesson: 30 min., $50.00")
  end

  scenario "does not specify required information" do
    click_link "Pricing Tiers"
    click_button "Create Pricing Tier"

    expect(page).to have_content("is not a number")
    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Pricing Tier Added")
  end
end
