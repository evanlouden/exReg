require "rails_helper"

feature "family accesses dashboard via root path" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, family: family1) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  scenario "successfully accesses dashboard" do
    sign_in_as(family1)
    click_link "New Student"
    visit family_root_path

    expect(page).to have_content(student1.full_name)
  end
end
