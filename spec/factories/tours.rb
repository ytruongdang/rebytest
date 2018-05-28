require "faker"

FactoryGirl.define do
  factory :tour do
    name {Faker::Name.name}
    price_per_person {Faker::Number.between 10, 100}
    description {Faker::Hipster.paragraph 20}
    num_people {Faker::Number.between 1, 20}
    duration {Faker::Number.between 1, 10}
    discount {Faker::Number.between 0, 90}
    category

    trait :large_picture do
      picture File.open Rails.root.join "spec/uploads/large_picture.jpeg"
    end

    trait :small_picture do
      picture File.open Rails.root.join "spec/uploads/small_picture.jpg"
    end

    before :create do |tour|
      tour.tour_dates.build(FactoryGirl.attributes_for :tour_date)
      tour.tour_places.build(FactoryGirl.attributes_for :tour_place)
    end
  end
end
