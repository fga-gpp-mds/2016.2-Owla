class Room < ApplicationRecord

  belongs_to :owner, class_name: 'Member', foreign_key: 'owner_id'
  has_many :topics, dependent: :destroy
  has_and_belongs_to_many :members

  serialize :black_list, Array

  validates :name, presence: true, length: { maximum: 255, minimum: 2 }
  validates :description, presence: true, length: { maximum: 240, minimum: 2 }

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

end
