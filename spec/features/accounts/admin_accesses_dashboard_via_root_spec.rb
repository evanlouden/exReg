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
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    click_link "All Staff"
    visit admin_root_path

    expect(page).to have_content("Admin Dashboard")
  end

  scenario "teacher tries to access admin dashboard" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: teacher1.email
    fill_in "Password", with: teacher1.password
    click_button "Sign In"
    visit admin_index_path

    expect(page).to have_content("You do not have permission to access this page")
    expect(page).to have_content(teacher1.full_name)
  end

  scenario "family tries to access admin dashboard" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    visit admin_index_path

    expect(page).to have_content("You do not have permission to access this page")
    expect(page).to have_content("New Student")
  end
end
