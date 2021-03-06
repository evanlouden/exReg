require "rails_helper"

feature "admin adds pricing tier" do
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
    fill_in "Tier Name", with: "Private Lesson"
    fill_in "Duration (minutes)", with: "30"
    fill_in "Price", with: "50"
    click_button "Create Pricing Tier"

    expect(page).to have_content("Pricing Tier Added")
    expect(page).to have_content("Private Lesson: 30 min., $50.00")
  end

  scenario "does not specify required information" do
    click_button "Create Pricing Tier"

    expect(page).to have_content("is not a number")
    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Pricing Tier Added")
  end

  scenario "specifies duration not multiple of 15" do
    fill_in "Duration (minutes)", with: "35"
    click_button "Create Pricing Tier"

    expect(page).to have_content("must be intervals of 15 minutes")
    expect(page).to_not have_content("Pricing Tier Added")
  end

  scenario "specifies duration less than 30" do
    fill_in "Duration (minutes)", with: "15"
    click_button "Create Pricing Tier"

    expect(page).to have_content("must be minimum of 30 minutes")
    expect(page).to_not have_content("Pricing Tier Added")
  end
end
