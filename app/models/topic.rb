class Topic < ApplicationRecord
  belongs_to :room
  has_many :questions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255, minimum: 2 }, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { maximum: 240, minimum: 2 }

  has_attached_file :slide
  validates_attachment :slide, content_type: { content_type: ["application/pdf"] }
end
