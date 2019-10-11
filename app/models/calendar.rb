class Calendar < ApplicationRecord
  has_many :user_calendars, dependent: :destroy
  has_many :users, through: :user_calendars
  has_many :calendar_events, dependent: :destroy
  has_many :events, through: :calendar_events
end
