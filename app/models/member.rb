class Member < ApplicationRecord

  acts_as_voter
  
  has_many :my_rooms, class_name: 'Room', foreign_key: 'owner_id'
  has_and_belongs_to_many :rooms
  has_many :questions
  has_many :answers

  has_many :received_reports, foreign_key: "reported_id"
  has_many :report_moderators, foreign_key: "moderator_id"
  has_and_belongs_to_many :reports

  has_many :tags

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 255, minimum: 3 }
  validates :alias, presence: true, length: { maximum: 40, minimum: 1 }, uniqueness: true
  validates :email, presence:true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { maximum:15, minimum: 6 }, if: :password_digest_changed?
  validates :password_confirmation, presence: true, length: { maximum:15, minimum: 6 }, if: :password_digest_changed?

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/missing.png"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_secure_password
end
