require "faker"
FactoryGirl.define do
  factory :booking do
    num_tourist 1
    contact_name {Faker::Name.name}
    contact_phone "123456789"
    contact_address {Faker::Hipster.paragraph 2}
    total_price {Faker::Number.between 10, 100}
    tour_date
    user
  end
end
