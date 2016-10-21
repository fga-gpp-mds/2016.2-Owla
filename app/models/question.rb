class Question < ApplicationRecord

  belongs_to :topic
  belongs_to :member
  has_many :answers, dependent: :destroy
  has_one :report

  validates :content, presence: true, length: { minimum: 5 }

end
