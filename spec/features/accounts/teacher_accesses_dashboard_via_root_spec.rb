require "rails_helper"

feature "teacher accesses dashboard via root path" do
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact1) { FactoryGirl.create(:contact, teacher: teacher1) }

  scenario "successfully accesses dashboard" do
    sign_in_as(teacher1)
    click_link "Edit Availability"
    visit teacher_root_path

    expect(page).to have_content(teacher1.staff_name)
    expect(page).to have_content("Edit Availability")
  end
end
