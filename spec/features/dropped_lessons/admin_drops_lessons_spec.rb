require "rails_helper"

feature "admin credits student with lessons", js: true do
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
  let!(:contact3) {
    FactoryGirl.create(
      :contact,
      family: family1,
      email: family1.email,
      first_name: "Jim",
      last_name: "Doe"
    )
  }
  let!(:student1) { FactoryGirl.create(:student, family: family1) }
  let!(:inquiry1) {
    FactoryGirl.create(
      :inquiry,
      student: student1,
      completed: true
    )
  }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:lesson1) {
    FactoryGirl.create(
      :lesson,
      start_date: Date.today - 15,
      attended: 3,
      student: student1,
      teacher: teacher1,
      inquiry: inquiry1
    )
  }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    within(:css, ".top-bar-right") do
      fill_in :query, with: student1.last_name
      find(".search-field").native.send_keys(:return)
    end
    click_link student1.full_name
  end
  scenario "successfully credits lessons" do
    fill_in "Lesson Amount", with: "2"

    using_wait_time 15 do
      page.has_css?("input", text: "150", visible: true)
    end

    select(Date.today + 6, from: "Effective Date")
    fill_in "Reason", with: "Had the flu"
    click_button "Drop Lessons"
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content("Lesson(s) Dropped")
    expect(page).to have_content("#{(lesson1.start_date + 21).strftime('%m/%d/%y')} - Dropped")
    expect(page).to have_content("#{(lesson1.start_date + 28).strftime('%m/%d/%y')} - Dropped")

    click_link("family-icon")

    expect(page).to have_content("+$150.00")
  end

  scenario "does not specify valid information" do
    click_button "Drop Lessons"
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Lesson(s) Dropped")
  end
end
