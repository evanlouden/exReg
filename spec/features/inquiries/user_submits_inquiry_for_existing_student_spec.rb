require "rails_helper"

feature "user submits new student inquiry" do
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
  scenario "existing user specifies valid information" do
    click_link "New Inquiry for #{student1.first_name}"
    select("Piano", from: "Instrument")
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Instrument: Piano")
  end

  scenario "existing user optionally adds notes to inquiry" do
    click_link "New Inquiry for #{student1.first_name}"
    select("Piano", from: "Instrument")
    fill_in "Additional Notes", with: "Some additional info"
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("Instrument: Piano")
  end
end
