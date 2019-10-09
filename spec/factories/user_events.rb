FactoryBot.define do
  factory :user_event do
    sequence(:user_id) { 1 }
    sequence(:event_id) { 1 }
    sequence(:accepted) { false }
  end
end