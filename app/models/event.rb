class Event < ApplicationRecord
  has_many :user_events
  has_many :users, throuth: :user_events
end
