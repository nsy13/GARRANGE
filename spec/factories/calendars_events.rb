FactoryBot.define do
  factory :calendar_event do
    sequence(:calendar_id) { 1 }
    sequence(:event_id) { 1 }
  end
end