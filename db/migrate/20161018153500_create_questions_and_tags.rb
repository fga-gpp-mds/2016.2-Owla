class CreateQuestionsAndTags < ActiveRecord::Migration[5.0]
  def change
    create_table :questions_tags, id:false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :tag, index: true
    end
  end
end
