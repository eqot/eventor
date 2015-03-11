require 'faker'

FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    visibility Event.visibilities[:everyone]

    association :invitation, factory: :event_invitation, strategy: :build

    association :owner_id, factory: :user

    after(:create) do |event|
      attendees = create_list(:user, 4)
      attendees.each do |attendee|
        create(:ticket, user_id: attendee.id, event_id: event.id)
      end

      invitees = create_list(:user, 4)
      invitees.each do |invitee|
        create(:target, user_id: invitee.id, event_id: event.id)
      end
    end

    factory :invalid_event do
      after(:build) do |event|
        event.title = nil
      end
    end
  end
end
