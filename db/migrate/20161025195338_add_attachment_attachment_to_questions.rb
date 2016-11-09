class AddAttachmentAttachmentToQuestions < ActiveRecord::Migration
  def self.up
    change_table :questions do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :questions, :attachment
  end
end
