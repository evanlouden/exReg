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
  let!(:association1) { FactoryGirl.create(:teacher_instrument, teacher: teacher2, instrument: instrument1) }

  before(:each) do
    sign_in_as(admin1)
  end
  scenario "successfully removes association" do
    click_link "Instrument Associations"
    click_link "Remove"

    expect(page).to have_content("Association removed")
    within(:css, "#teachinst-#{teacher2.contacts.first.first_name}-#{teacher2.contacts.first.last_name}") do
      expect(page).to_not have_content(instrument1.name)
    end
  end
end
