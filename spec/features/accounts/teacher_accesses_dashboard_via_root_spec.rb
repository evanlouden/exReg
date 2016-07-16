require "rails_helper"

feature "teacher accesses dashboard via root path" do
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact1) { FactoryGirl.create(:contact, teacher: teacher1) }

  scenario "successfully accesses dashboard" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"
    click_link "Edit Availability"
    visit teacher_root_path

    expect(page).to have_content(teacher1.full_name)
    expect(page).to have_content("Edit Availability")
  end
end
