class AddIndexToUserCalendars < ActiveRecord::Migration[5.2]
  def change
    add_index :user_calendars, [:user_id, :calendar_id], unique: true
  end
end
