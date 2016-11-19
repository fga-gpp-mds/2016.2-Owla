module ApplicationCable
  class Channel < ActionCable::Channel::Base
    attr_accessor :current_member

    def connect
      self.current_member = find_verified_user
    end

    protected
      def find_verified_user
        if self.current_member = User.find_by(id: cookies[:member_id])
          self.current_member
        else
          reject_unauthorized_connection
        end
      end
  end
end
