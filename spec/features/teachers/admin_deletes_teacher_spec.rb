require "rails_helper"

feature "admin deletes teacher" do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact1) { FactoryGirl.create(:contact, teacher: teacher1) }

  scenario "successfully deletes teacher" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link "Staff Members"
    click_link "Delete Teacher"

    expect(page).to have_content("Teacher deleted")
    expect(page).to_not have_content(contact1.first_name)
  end
end
