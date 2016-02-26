FactoryGirl.define do
  factory :song do
    title Faker::Lorem.sentence(3)
  end
end
