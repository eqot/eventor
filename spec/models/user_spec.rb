require 'rails_helper'

RSpec.describe User, type: :model do
  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:password) }

  it 'should be valid with name' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'should be invalid without email' do
    user = build(:user_without_email)
    expect(user).to have(1).errors_on(:email)
  end

  it 'should be invalid without name' do
    user = build(:user_without_name)
    expect(user).to have(1).errors_on(:name)
  end
end
