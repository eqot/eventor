require "faker"

Faker::Config.locale = :en

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { Faker::Internet.password(8) }

    factory :user_without_email do
      after(:build) do |user|
        user.email = nil
      end
    end

    factory :user_without_name do
      after(:build) do |user|
        user.name = nil
      end
    end
  end
end
