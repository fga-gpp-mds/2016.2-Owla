class Notification < ApplicationRecord

	belongs_to :receiver, class_name: 'Member', foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'Member', foreign_key: 'sender_id', optional: true

  validates :message, presence: true, length: { minimum: 5, maximum: 255 }

end
