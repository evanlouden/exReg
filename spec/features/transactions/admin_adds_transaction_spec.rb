require "rails_helper"

feature "admin adds transaction", js: true do
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
      first_name: "Ted",
      last_name: "Williams"
    )
  }
  let!(:student1) { FactoryGirl.create(:student, family: family1, last_name: "Williams") }
  let!(:inquiry1) { FactoryGirl.create(:inquiry, student: student1) }
  let!(:price1) { FactoryGirl.create(:price) }
  let!(:price2) { FactoryGirl.create(:price, duration: "60", price: "100") }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:lesson1) {
    FactoryGirl.create(
      :lesson,
      student: student1,
      teacher: teacher1,
      inquiry: inquiry1,
      start_date: Date.today.strftime("%F"),
      day: Date.today.strftime("%A")
    )
  }
  let!(:reason1) { FactoryGirl.create(:reason) }
  let!(:reason2) {
    FactoryGirl.create(
      :reason,
      reason: "Unexcused Absence",
      student_charged: true,
      teacher_paid: true
    )
  }

  before(:each) do
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: admin1.email
    fill_in "Password", with: admin1.password
    click_button "Sign In"
    within(:css, ".top-bar-right") do
      fill_in :query, with: "Will"
      find(".search-field").native.send_keys(:return)
    end
    click_link("family-icon")
  end
  scenario "successfully adds debit" do
    choose("transaction_type_debit")
    fill_in "Amount", with: "500"
    click_button "Add Transaction"

    expect(page).to have_content("Debit Added")
    expect(page).to have_content("$500.00")
    expect(page).to have_content(Time.now.getutc.to_date.strftime("%-m/%-d/%Y"))
  end

  scenario "successfully adds credit" do
    choose("transaction_type_credit")
    fill_in "Amount", with: "500"
    click_button "Add Transaction"

    expect(page).to have_content("Credit Added")
    expect(page).to have_content("-$500.00")
    expect(page).to have_content(Time.now.getutc.to_date.strftime("%-m/%-d/%Y"))
  end

  scenario "does not specify required information" do
    click_button "Add Transaction"

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("-$500.00")
  end

  scenario "does not specify minimum amount" do
    choose("transaction_type_credit")
    click_button "Add Transaction"

    expect(page).to have_content("greater than 0")
    expect(page).to_not have_content("-$500.00")
  end
end
