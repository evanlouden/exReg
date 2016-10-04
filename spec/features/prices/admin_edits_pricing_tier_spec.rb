require "rails_helper"

feature "admin edits pricing tier" do
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
  let!(:price1) { FactoryGirl.create(:price) }

  before(:each) do
    sign_in_as(admin1)
    within(:css, ".top-bar-right") do
      click_link("settings-cog")
    end
    click_link("edit-price")
  end
  scenario "specifies valid information" do
    fill_in "Duration (minutes)", with: "75"
    click_button "Update Pricing Tier"

    expect(page).to have_content("Pricing Tier Updated")
    expect(page).to have_content("#{price1.tier_name}: 75 min., $#{'%.2f' % price1.price}")
  end

  scenario "does not specify required information" do
    fill_in "Tier Name", with: ""
    click_button "Update Pricing Tier"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Pricing Tier Updated")
  end
end
