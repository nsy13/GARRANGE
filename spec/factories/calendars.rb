FactoryBot.define do
  factory :calendar do
    name { Faker::Beer.name }
    color { Faker::Color.hex_color }
  end
end