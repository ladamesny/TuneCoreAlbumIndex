FactoryGirl.define do
  factory :album do
    title Faker::Lorem.sentence(3)
  end
end
