require "faker"

FactoryGirl.define do
  factory :tour_date do
    start_date {Faker::Date.between(2.days.ago, Date.today)}
  end
end
