require "faker"

FactoryGirl.define do
  factory :event_invitation do
    time = Faker::Time.forward(7)
    start_time { time }
    end_time { time + 1.hour }

    location { Faker::Address.city }
  end
end
