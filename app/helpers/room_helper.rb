module RoomHelper

  def is_owner
    topic = Topic.find_by(id: params[:id])
    room = topic.room
    member = current_member

    unless room.owner == member
      flash[:notice] = "You do not have permission to do this action"
      redirect_to topic_path(topic)
    end
  end

end
