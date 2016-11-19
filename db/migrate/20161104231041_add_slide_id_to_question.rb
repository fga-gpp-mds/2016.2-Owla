class AddSlideIdToQuestion < ActiveRecord::Migration[5.0]
  def up
    add_column :questions, :slide_id, :integer
  end

  def down
    remove_column :questions, :slide_id, :integer
  end
end
