require "faker"

FactoryGirl.define do
  factory :event_invitation do
    sequence(:start_time) { |n| Time.now + n.days }
    end_time { start_time + 1.hour }

    location { Faker::Address.city }
  end
end
