require "rails_helper"

feature "admin views student inquiry" do
  let!(:admin1) { FactoryGirl.create(:account, admin: true) }
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "views student inquiry" do
    within(:css, "#admin-inquiries") do
      click_link "#{student1.full_name}"
    end

    expect(page).to have_content(student1.first_name)
    expect(page).to have_content(student1.last_name)
    expect(page).to have_content(inquiry1.instrument)
  end
end
