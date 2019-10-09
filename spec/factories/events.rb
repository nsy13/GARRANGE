FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "Event No.#{n}" }
    sequence(:description) { |n| "Test No.#{n}Test No.#{n}Test No.#{n}" }
    sequence(:start_date) { |n| Time.current + n*100 }
    sequence(:end_date) { |n| Time.current + n*200 }
    sequence(:organizer_id) { 1 }
    sequence(:place) { |n| "Meeting Room #{n}" }
  end
end