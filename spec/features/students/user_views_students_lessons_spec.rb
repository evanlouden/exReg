require "rails_helper"

feature "user views registered students' lessons" do
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
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1, completed: true) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:lesson1) { FactoryGirl.create(:lesson, student: student1, teacher: teacher1, inquiry: inquiry1) }

  scenario "views list of lessons" do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: family1.email
    fill_in "Password", with: family1.password
    click_button "Sign In"

    within(:css, "#lessons-#{lesson1.student.first_name}-#{lesson1.instrument}") do
      expect(page).to have_content(lesson1.time_info)
      expect(page).to have_content(lesson1.price_info)
      expect(page).to have_content(lesson1.remaining_balance)
    end
  end
end
