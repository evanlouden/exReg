require "rails_helper"

feature "adminteacher accesses dashboard via root path" do
  let!(:teacher1) { FactoryGirl.create(:teacher, admin: true) }
  let!(:contact1) { FactoryGirl.create(:contact, teacher: teacher1) }

  scenario "successfully accesses dashboard" do
    visit unauthenticated_root_path
    sign_in_as(teacher1)

    expect(page).to have_content("Admin Dashboard")

    click_link "All Staff"
    visit adminteacher_root_path

    expect(page).to have_content("Admin Dashboard")
  end
end
