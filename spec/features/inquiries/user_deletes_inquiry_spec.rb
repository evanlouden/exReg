require "rails_helper"

feature "user deletes a student and inquiry" do
  let!(:user1) { FactoryGirl.create(:account) }
  let!(:user2) { FactoryGirl.create(:account) }
  let!(:student1) { FactoryGirl.create(:student, account: user1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }

  scenario "existing user successfully deletes student and inquiry" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user1.email
    fill_in "Password", with: user1.password
    click_button "Sign In"
    click_link "Delete Student"

    expect(page).to have_content("Student and inquiry deleted")
    expect(page).to_not have_content(student1.full_name)
  end

  scenario "user attempts to delete another account's student" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: user2.email
    fill_in "Password", with: user2.password
    click_button "Sign In"
    page.driver.submit :delete, "/students/#{student1.id}", {}

    expect(page).to have_content("You are not authorized to delete this student")
  end
end
