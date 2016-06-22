# require "rails_helper"
#
# feature "admin signs up teacher" do
#   let!(:admin1) { FactoryGirl.create(:account, admin: true) }
#
#   before(:each) do
#     visit unauthenticated_root_path
#     click_link "Sign In"
#     fill_in "Email", with: admin1.email
#     fill_in "Password", with: admin1.password
#     click_button "Sign In"
#   end
#   scenario "specifies valid account information" do
#     click_link "Add Teacher"
#     fill_in "Email", with: "newteacher@teacher.com"
#     fill_in "Address", with: "100 Main Street"
#     fill_in "City", with: "Boston"
#     fill_in "State", with: "MA"
#     fill_in "Zip", with: "02115"
#     find(:css, "#teacher-checkbox").set(true)
#     click_button "Create Account"
#
#     expect(page).to have_content("Account created")
#     expect(page).to have_content("Admin Dashboard")
#     expect(page).to have_content("newteacher@teacher.com")
#   end
#
#   scenario "does not specify valid account information" do
#     click_link "Add Teacher"
#     click_button "Create Account"
#
#     expect(page).to have_content("New Teacher Account")
#     expect(page).to have_content("can't be blank")
#     expect(page).to_not have_content("Admin Dashboard")
#   end
# end
