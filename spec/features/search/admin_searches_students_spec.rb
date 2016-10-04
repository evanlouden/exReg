require "rails_helper"

feature "admin searches for students", js: true do
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
  let!(:family1) { FactoryGirl.create(:family) }
  let!(:contact2) {
    FactoryGirl.create(
      :contact,
      family: family1,
      email: family1.email,
      first_name: "Ted",
      last_name: "Williams"
    )
  }
  let!(:student1) {
    FactoryGirl.create(
      :student,
      family: family1,
      first_name: "Jimmy",
      last_name: "Williams"
    )
  }
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
      student: student1,
      teacher: teacher1,
      inquiry: inquiry1
    )
  }
  let!(:student2) {
    FactoryGirl.create(
      :student,
      family: family1,
      first_name: "Billy",
      last_name: "Williams"
    )
  }
  let!(:inquiry2) {
    FactoryGirl.create(
      :inquiry,
      student: student2,
      completed: true
    )
  }
  let!(:family2) { FactoryGirl.create(:family) }
  let!(:contact3) {
    FactoryGirl.create(
      :contact,
      family: family2,
      email: family2.email,
      first_name: "Bill",
      last_name: "Johnson"
    )
  }
  let!(:student3) {
    FactoryGirl.create(
      :student,
      family: family2,
      first_name: "Jamie",
      last_name: "Johnson"
    )
  }
  let!(:inquiry3) {
    FactoryGirl.create(
      :inquiry,
      student: student3,
      completed: true
    )
  }
  let!(:teacher1) { FactoryGirl.create(:teacher) }
  let!(:contact4) { FactoryGirl.create(:contact, email: teacher1.email, teacher: teacher1) }

  before(:each) do
    sign_in_as(admin1)
  end
  scenario "successfully finds students" do
    within(:css, ".top-bar-right") do
      fill_in :query, with: "Will"
      find(".search-field").native.send_keys(:return)
    end

    expect(page).to have_content(student1.full_name)
    expect(page).to have_content(student2.full_name)
    expect(page).to_not have_content(student3.full_name)
  end

  scenario "specifies invalid search query" do
    within(:css, ".top-bar-right") do
      fill_in :query, with: "x"
      find(".search-field").native.send_keys(:return)
    end

    expect(page).to have_content("Sorry, but we couldn't find anything matching 'x'")
  end
end
