class AddAnonymousToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :anonymous, :boolean, default: false
  end
end
