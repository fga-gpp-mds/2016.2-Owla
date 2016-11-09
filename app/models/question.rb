class Question < ApplicationRecord
  
  acts_as_votable
  belongs_to :topic
  belongs_to :member
  has_many :answers, dependent: :destroy

  has_one :report

  has_and_belongs_to_many :tags

  validates :content, presence: true, length: { minimum: 5 }

  has_attached_file :attachment

  validates_attachment_file_name :attachment, :matches => [/^.*\.(doc|docx|odp|ods|odt|pdf|ppt|pptx|xls|xlsx|jpeg|jpg|png)$/]

end
