FactoryGirl.define do
  factory :artist do
    name Faker::Lorem.sentence(3)
  end
end
