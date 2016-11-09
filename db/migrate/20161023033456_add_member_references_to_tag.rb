class AddMemberReferencesToTag < ActiveRecord::Migration[5.0]
  def change
  	add_reference :tags, :member, foreign_key: true
  end
end
