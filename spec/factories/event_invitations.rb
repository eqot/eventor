require "faker"

FactoryGirl.define do
  factory :event_invitation do
    start_time { Faker::Time.forward(7) }
    end_time { start_time + 1.hour }
    max_attendees 4

    location { Faker::Address.city }
  end
end
