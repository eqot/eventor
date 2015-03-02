require "faker"

FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }

    association :invitation, factory: :event_invitation, strategy: :build

    association :owner_id, factory: :user

    factory :invalid_event do
      after(:build) do |event|
        event.title = nil
      end
    end
  end
end
