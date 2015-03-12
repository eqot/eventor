require 'rails_helper'

describe Notification do
  it { should respond_to(:description) }
  it { should respond_to(:image) }
  it { should respond_to(:url) }

  it 'should have right notificated users' do
    user1 = create(:user)
    user2 = create(:user)

    notification = create(:notification)
    notification.notify!(user1)
    notification.notify!(user2)

    expect(notification.users).to match_array([user1, user2])
  end

  it 'should have right notificated users without checked users' do
    user1 = create(:user)
    user2 = create(:user)

    notification = create(:notification)
    notification.notify!(user1)
    notification.notify!(user2)

    notification.checked!(user1)

    expect(notification.users).to match_array([user2])
  end
end
