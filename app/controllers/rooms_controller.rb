class RoomsController < ApplicationController

  skip_before_action :verify_authenticity_token if Rails.env.test?
  before_action :authenticate_member
  before_action :is_owner, only: [:ban_member, :banned_members, :reintegrate_member]

  def index
    @rooms = Room.all
  end

  def new
    @member = Member.find(params[:member_id])
    @room = Room.new
    @room.owner = @member

    @box_title = "Create your own room"
    @subtitle  = "Create"
    @placeholder_name = "Title"
    @placeholder_description = "Description"
    @url = member_rooms_path(@member)
  end

  def signup
    member = current_member
    room = Room.find(params[:id])

    if room.black_list.include?(current_member.id)
      flash[:notice] = "You are not allowed to join this room"
    elsif room.members.include?(member)
      flash[:notice] = "You are already registered in this room"
    else
      room.members << member
      send_notification("joined_room", room)
    end

    redirect_to room_path(room)
  end

  def signout
    member = current_member
    room = Room.find(params[:id])

    if room.members.include?(member)
      room.members.delete(member)
      member.rooms.delete(room)
    else
      flash[:notice] = "You are not registered in this room"
    end

    redirect_to room_path(room)
  end

  def show
    @room = Room.find(params[:id])
  end

  def edit
    @room = Room.find(params[:id])
    @box_title = "Edit your room"
    @subtitle  = "Settings"
    @placeholder_name = @room.name
    @placeholder_description = @room.description
    @url = room_path(@room)
  end

  def create
    @room = Room.new(room_params)
    @room.owner = current_member

    if @room.save
      redirect_to room_path(@room)
    else
      flash[:alert] = "Error creating room"
      redirect_to new_member_room_path(current_member.id)
    end
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(room_params)
      redirect_to room_path(@room)
    else
      flash[:alert] = "Error updating room"
      render 'edit'
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    redirect_to member_rooms_path(current_member)
  end

  def ban_member
    member = Member.find(params[:member_id])
    topic = Topic.find(params[:topic_id])
    room = topic.room

    room.black_list << member.id
    room.members.delete(member)
    room.save

    flash[:notice] = "The member was banned from your room"

    redirect_to topic_path topic
  end

  def banned_members
    room = Room.find(params[:id])
    @banned_members = Member.where(id: room.black_list)
  end

  def reintegrate_member
    @room = Room.find(params[:id])
    @room.black_list.delete(params[:member_id].to_i)
    @room.save

    flash[:notice] = "Member has been removed from black list and can now join the room"
    redirect_to banned_members_url
  end

  private
    def room_params
      params.require(:room).permit(:name, :description, :member_id)
    end

end
