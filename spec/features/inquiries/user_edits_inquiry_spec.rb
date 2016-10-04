require "rails_helper"

feature "user edits student inquiry" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  scenario "existing user successfully edits inquiry" do
    sign_in_as(family1)
    visit dashboard_index_path
    click_link("edit-inquiry")
    select("Piano", from: "Instrument")
    click_button "Update Inquiry"

    expect(page).to have_content("Inquiry Updated")
    expect(page).to have_content("Pending Piano Inquiry")
  end
end
