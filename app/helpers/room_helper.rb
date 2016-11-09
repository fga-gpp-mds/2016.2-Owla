module RoomHelper

  def is_owner
    room = Topic.find_by(id: params[:id]).room
    member = current_member
    unless room.owner == member
      flash[:notice] = "You do not have permission to do this action"
      redirect_to home_path(member)
    end
  end

end
