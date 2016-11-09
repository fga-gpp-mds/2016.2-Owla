class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.text :explanation
      t.belongs_to :moderator
      t.belongs_to :reported
      t.belongs_to :answer
      t.belongs_to :question
      t.timestamps
    end

    create_table :members_reports, id:false do |t|
      t.belongs_to :report, index:true
      t.belongs_to :member, index:true
    end
  end
end
