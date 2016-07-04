require "rails_helper"

feature "admin changes teacher's admin status" do
  let!(:admin1) { FactoryGirl.create(:admin) }
  let!(:teacher1) { FactoryGirl.create(:teacher) }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
  end
  scenario "designates admin" do
    click_link "Staff Members"
    click_link "Make Admin"

    within(:css, "#admin-admins") do
      expect(page).to have_content(teacher1.email)
    end
    expect(page).to have_content("Revoke Admin")
  end

  scenario "revokes admin" do
    click_link "Staff Members"
    click_link "Make Admin"
    click_link "Revoke Admin"

    within(:css, "#admin-admins") do
      expect(page).to_not have_content(teacher1.email)
    end
    expect(page).to_not have_content("Revoke Admin")
  end
end
