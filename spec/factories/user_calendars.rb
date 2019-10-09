FactoryBot.define do
  factory :user_calendar do
    sequence(:user_id) { 1 }
    sequence(:calendar_id) { 1 }
    sequence(:owner) { false }
  end
end