class AddCalendarIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :calender_id, :integer
  end
end
