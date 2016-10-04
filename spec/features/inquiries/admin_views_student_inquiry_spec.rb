require "rails_helper"

feature "admin views student inquiry" do
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
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  scenario "views student inquiry" do
    sign_in_as(admin1)
    within(:css, "#admin-inquiries") do
      click_link student1.full_name
    end

    expect(page).to have_content(student1.first_name)
    expect(page).to have_content(student1.last_name)
    expect(page).to have_content(inquiry1.instrument)
  end
end
