class AddColumnToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :organizer_id, :integer
  end
end
