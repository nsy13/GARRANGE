class Event < ApplicationRecord
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  has_many :calendar_events, dependent: :destroy
  has_many :calendars, through: :calendar_events
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }
end
