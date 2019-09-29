class AddPlaceToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :place, :string
  end
end
