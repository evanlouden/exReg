require "rails_helper"

feature "admin adds teacher instrument association" do
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
  let!(:contact2) { FactoryGirl.create(:contact, email: teacher1.email, teacher: teacher1) }
  let!(:teacher2) { FactoryGirl.create(:teacher) }
  let!(:contact3) { FactoryGirl.create(:contact, first_name: "Tom", email: teacher2.email, teacher: teacher2) }
  let!(:instrument1) { FactoryGirl.create(:instrument) }
  let!(:instrument2) { FactoryGirl.create(:instrument, name: "Piano") }


  before(:each) do
    sign_in_as(admin1)
  end
  scenario "successfully adds association" do
    click_link "Instrument Associations"
    select(teacher2.staff_name, from: :teacher_instrument_teacher_id)
    select(instrument1.name, from: :teacher_instrument_instrument_id)
    click_button "Add Association"

    expect(page).to have_content("Instrument associated")
    within(:css, "#teachinst-#{teacher2.contacts.first.first_name}-#{teacher2.contacts.first.last_name}") do
      expect(page).to have_content(instrument1.name)
    end
  end

  scenario "adds duplicate association" do
    click_link "Instrument Associations"
    select(teacher2.staff_name, from: :teacher_instrument_teacher_id)
    select(instrument1.name, from: :teacher_instrument_instrument_id)
    click_button "Add Association"
    select(teacher2.staff_name, from: :teacher_instrument_teacher_id)
    select(instrument1.name, from: :teacher_instrument_instrument_id)
    click_button "Add Association"

    expect(page).to have_content("Instrument has already been taken")
  end
end
