FactoryBot.define do
  factory :event do
    title { Faker::Job.title }
    description { Faker::Lorem.sentence }
    start_date { Faker::Date.between(from: 2.days.ago, to: 5.days.from_now) }
    end_date { start_date + 3.hours }
    place { Faker::Restaurant.name }
  end
end
