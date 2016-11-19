class NotificationsController < ApplicationController

	def index
		@notifications = current_member.received_notifications.reverse

    @notifications.each do |p|
      p.update_attribute(:read, true)
    end
	end

end
