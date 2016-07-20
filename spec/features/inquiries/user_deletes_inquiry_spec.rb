require "rails_helper"

feature "user deletes a student and inquiry" do
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact1) { FactoryGirl.create(:contact, email: family1.email, family: family1) }
  let!(:family2) { FactoryGirl.create(:family) }
  let!(:contact2) { FactoryGirl.create(:contact, email: family2.email, family: family2) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }

  scenario "existing user successfully deletes student and inquiry" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"
    click_link "Delete Student"

    expect(page).to have_content("Student and inquiry deleted")
    expect(page).to_not have_content(student1.full_name)
  end

  scenario "user attempts to delete another account's student" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family2.email
    fill_in "Password", with: family2.password
    click_button "Sign In"
    page.driver.submit :delete, "/students/#{student1.id}", {}

    expect(page).to have_content("You are not authorized to delete this student")
  end
end
