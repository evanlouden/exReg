require "rails_helper"

feature "admin changes teacher's admin status" do
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

  before(:each) do
    sign_in_as(admin1)
  end
  scenario "designates admin" do
    click_link "All Staff"
    click_link "Make Admin"

    within(:css, "#admin-admins") do
      expect(page).to have_content(teacher1.staff_name)
    end
    expect(page).to have_content("Revoke Admin")
  end

  scenario "revokes admin" do
    click_link "All Staff"
    click_link "Make Admin"
    click_link "Revoke Admin"

    within(:css, "#admin-admins") do
      expect(page).to_not have_content(teacher1.staff_name)
    end
    expect(page).to_not have_content("Revoke Admin")
  end
end
