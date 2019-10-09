class AddColorToCalendars < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :color, :string
  end
end
