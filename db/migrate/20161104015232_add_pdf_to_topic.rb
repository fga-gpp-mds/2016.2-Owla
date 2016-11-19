class AddPdfToTopic < ActiveRecord::Migration[5.0]
  def up
		add_attachment :topics, :slide
	end

	def down
		remove_attachment :topics, :slide
	end
end
