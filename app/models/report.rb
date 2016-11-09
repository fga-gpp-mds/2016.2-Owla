class Report < ApplicationRecord
  belongs_to :moderator, class_name: "Member", foreign_key: "moderator_id"
  belongs_to :reported, class_name: "Member", foreign_key: "reported_id"
  has_and_belongs_to_many :members
  belongs_to :question, optional: true
  belongs_to :answer, optional: true
end
