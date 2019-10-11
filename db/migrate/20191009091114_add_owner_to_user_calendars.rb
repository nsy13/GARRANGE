class AddOwnerToUserCalendars < ActiveRecord::Migration[5.2]
  def change
    add_column :user_calendars, :owner, :boolean
  end
end
