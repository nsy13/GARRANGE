class AddColumnToUserEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :user_events, :accepted, :boolean, default: false
  end
end
