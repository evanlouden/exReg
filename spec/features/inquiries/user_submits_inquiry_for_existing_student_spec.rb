require "rails_helper"

feature "user submits inquiry for existing student" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  before(:each) do
    sign_in_as(family1)
    click_link student1.full_name
    click_link("add-inquiry")
    select("Piano", from: "Instrument")
  end
  scenario "existing user specifies valid information" do
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Pending Piano Inquiry")
  end

  scenario "existing user optionally adds notes to inquiry" do
    fill_in "Additional Notes", with: "Some additional info"
    click_button "Submit Inquiry"

    expect(page).to have_content("Inquiry Submitted")
    expect(page).to have_content("Pending Piano Inquiry")
  end
end
