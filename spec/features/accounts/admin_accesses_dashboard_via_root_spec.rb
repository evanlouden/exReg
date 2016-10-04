require "rails_helper"

feature "admin accesses dashboard via root path" do
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
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact2) { FactoryGirl.create(:contact, teacher: teacher1) }
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact3) { FactoryGirl.create(:contact, email: family1.email, family: family1) }

  scenario "successfully accesses dashboard" do
    sign_in_as(admin1)
    click_link "All Staff"
    visit admin_root_path

    expect(page).to have_content("Admin Dashboard")
  end

  scenario "teacher tries to access admin dashboard" do
    sign_in_as(teacher1)
    visit admin_index_path

    expect(page).to have_content("You do not have permission to access this page")
    expect(page).to have_content(teacher1.staff_name)
  end

  scenario "family tries to access admin dashboard" do
    sign_in_as(family1)
    visit admin_index_path

    expect(page).to have_content("You do not have permission to access this page")
    expect(page).to have_content("New Student")
  end
end
