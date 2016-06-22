require "rails_helper"

feature "admin views student inquiry" do
  let!(:admin1) { FactoryGirl.create(:account, admin: true) }
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "successfully marks completed" do
    click_link "#{student1.first_name} #{student1.last_name}"

    expect(page).to have_content(student1.first_name)
    expect(page).to have_content(student1.last_name)
    expect(page).to have_content(inquiry1.instrument)
  end
end
