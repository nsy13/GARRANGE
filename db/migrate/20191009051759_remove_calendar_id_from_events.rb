class RemoveCalendarIdFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :calendar_id, :bigint
  end
end
