require "rails_helper"

feature "adminteacher accesses dashboard via root path" do
  let!(:teacher1) { FactoryGirl.create(:teacher, admin: true) }
  let!(:contact1) { FactoryGirl.create(:contact, teacher: teacher1) }

  scenario "successfully accesses dashboard" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"

    expect(page).to have_content("Admin Dashboard")

    click_link "Staff Members"
    visit adminteacher_root_path

    expect(page).to have_content("Admin Dashboard")
  end
end
