FactoryBot.define do
  factory :calendar do
    sequence(:name) { |n| "Calendar No.#{n}" }
    sequence(:color) { "#fff" }
  end
end