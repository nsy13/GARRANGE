class AddDefaultOwnerToUserCalendars < ActiveRecord::Migration[5.2]
  def change
    change_column :user_calendars, :owner, :boolean, :default => false
  end
end
