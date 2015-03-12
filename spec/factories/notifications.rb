require 'faker'

FactoryGirl.define do
  factory :notification do
    description { Faker::Lorem.sentence }
    image { Faker::Lorem.sentence }
    url { Faker::Internet.url }
  end
end
