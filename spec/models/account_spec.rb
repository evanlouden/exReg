require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should have_valid(:email).when('user@example.com', 'another@gmail.com') }
  it { should_not have_valid(:email).when(nil, '', 'another@gmailcom') }

  it { should have_valid(:address).when('123 Main Street', '14 Pond Avenue') }
  it { should_not have_valid(:address).when(nil, '') }

  it { should have_valid(:city).when('Boston', 'Chicago') }
  it { should_not have_valid(:city).when(nil, '') }

  it { should have_valid(:zip).when('02347', '12345') }
  it { should_not have_valid(:zip).when(nil, '', 'ADBEHD') }

  it { should have_valid(:state).when('MA', 'CA') }
  it { should_not have_valid(:state).when(nil, '') }

  it 'has a matching password confirmation for password' do
    account = Account.new
    account.password = 'password'
    account.password_confirmation = 'anotherpassword'

    expect(account).to_not be_valid
    expect(account.errors[:password_confirmation]).to_not be_blank
  end
end
