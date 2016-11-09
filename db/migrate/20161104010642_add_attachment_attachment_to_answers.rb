class AddAttachmentAttachmentToAnswers < ActiveRecord::Migration
  def self.up
    change_table :answers do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :answers, :attachment
  end
end
