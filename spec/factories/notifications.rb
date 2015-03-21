require 'faker'

FactoryGirl.define do
  factory :notification do
    description { Faker::Lorem.sentence }
    association :content, factory: :event
  end
end
