class Event < ApplicationRecord
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  has_many :calendar_events, dependent: :destroy
  has_many :calendars, through: :calendar_events
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }
  validate :date_check

  def date_check
    if start_date.blank?
      errors.add(:start_date, "を入力してください")
    elsif end_date.blank?
      errors.add(:end_date, "を入力してください")
    elsif start_date > end_date
      errors.add(:end_date, "の日付を正しく記入してください")
    end
  end
end
