require "rails_helper"

feature "user edits student inquiry" do
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
  end
  scenario "existing user successfully edits inquiry form" do
    visit dashboard_index_path
    click_link "Edit Inquiry"
    select("Piano", from: "Instrument")
    click_button "Update Inquiry"

    expect(page).to have_content("Inquiry Updated")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Instrument: Piano")
  end
end
