class CreateCalendarEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_events do |t|
      t.references :calendar, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
