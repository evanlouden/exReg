require "rails_helper"

feature "user submits new student inquiry" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    click_link student1.full_name
    click_link "New Inquiry"
  end
  scenario "existing user specifies valid information" do
    select("Piano", from: "Instrument")
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Pending Piano Inquiry")
  end

  scenario "existing user optionally adds notes to inquiry" do
    select("Piano", from: "Instrument")
    fill_in "Additional Notes", with: "Some additional info"
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Pending Piano Inquiry")
  end
end
