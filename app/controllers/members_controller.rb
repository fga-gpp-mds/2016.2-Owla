class MembersController < ApplicationController
  skip_before_action :verify_authenticity_token if Rails.env.test?
  before_action :authenticate_member, except: [:new, :create]

  def new
    @member = Member.new
  end

  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
  end

  def create
    @member = Member.new(member_params)

    if @member.save
      log_in @member
      redirect_to home_path @member

      send_notification("first_notification", nil)
    else
      flash[:alert] = "Member not created"
      render 'new'
    end
  end

  def update
    @member = Member.find(params[:id])

    if @member.update_attributes(member_params)
      redirect_to members_path
    else
      flash[:alert] = "Member not updated"
      render 'edit'
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    redirect_to members_path
  end

  def home
    @member = Member.find(params[:id])
  end

  def joined_rooms
    @rooms = current_member.rooms.all + current_member.my_rooms.all
    @subtitle = 'Joined rooms'
    render 'rooms'
  end

  def my_rooms
    @rooms = current_member.my_rooms.all
    @subtitle = 'My own rooms'
    render 'rooms'
  end

  private

    def member_params
      params.require(:member).permit(:name, :alias, :password, :email, :password_confirmation, :avatar)
    end

end
