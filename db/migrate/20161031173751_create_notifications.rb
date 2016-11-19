class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.text :message
      t.boolean :read, default: :false
      t.integer :receiver_id
      t.integer :sender_id
      t.string :link

      t.timestamps
    end
  end
end
