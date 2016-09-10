require "rails_helper"

feature "user edits student inquiry" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  scenario "existing user successfully edits inquiry" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    visit dashboard_index_path
    click_link("edit-inquiry")
    select("Piano", from: "Instrument")
    click_button "Update Inquiry"

    expect(page).to have_content("Inquiry Updated")
    expect(page).to have_content("Pending Piano Inquiry")
  end
end
