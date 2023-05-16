class AddStatusToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :status, :string
  end
end
