class AddBlackListToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :black_list, :text
  end
end
