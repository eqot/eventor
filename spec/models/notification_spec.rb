require 'rails_helper'

describe Notification do
  it { should respond_to(:description) }
  it { should respond_to(:content) }

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

  it 'should have right content to invited event' do
    user = create(:user)

    event = create(:event)
    event.invite!(user)

    expect(user.notifications[0].content).to eq(event)
  end

  it 'should have right notificated user when user is invited to event' do
    user = create(:user)

    event1 = create(:event)
    event1.invite!(user)
    event2 = create(:event)
    event2.invite!(user)

    expect(user.notifications).to have(2).items
  end

  it 'should have right notificated user when user is invited to event after uninvited' do
    user = create(:user)

    event1 = create(:event)
    event1.invite!(user)
    event2 = create(:event)
    event2.invite!(user)
    event2.uninvite!(user)

    expect(user.notifications).to have(1).items
  end

  it 'should be removed if there are no users' do
    user = create(:user)

    event1 = create(:event)
    event1.invite!(user)
    event1.uninvite!(user)

    expect(Notification.all).to have(0).items
  end
end
