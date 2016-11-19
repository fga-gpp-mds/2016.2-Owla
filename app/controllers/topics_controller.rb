class TopicsController < ApplicationController
  include TopicsHelper
  include RoomHelper

  skip_before_action :verify_authenticity_token if Rails.env.test?
  before_action :authenticate_member
  before_action :is_joined, only: [:show]
  before_action :is_owner, only: [:destroy, :edit, :update]

  def show
    @topic = Topic.find(params[:id])
    @question = Question.new
    @answer = Answer.new
    @room = Room.find(@topic.room_id)
    @owner = @room.owner
    @new_question_url = {:action=>"create", :controller=>"questions", :id=>nil, topic_id: @topic.id}
    @question_placeholder = "Type your question here"
    @question_box_title = "Create a new question"

    if @topic.slide.present?
      @slide = {
        pages: generate_slide_list(@topic),
        dimensions: get_image_dimensions(@topic.slide),
        questions: get_slide_questions_list(@topic, params[:slide_id])
      }
    end

    cookies[:room_owner_id] = @room.owner.id
  end

  def new
    @room = Room.find(params[:room_id])
    @topic = Topic.new
    @box_title = "Create a topic"
    @subtitle  = "Create"
    @placeholder_name = "Title"
    @placeholder_description = "Description"
  end

  def create
    @topic = Topic.new(topic_params)
    @room = Room.find(params[:room_id])
    @topic.room = @room
    if @topic.save
      redirect_to topic_path(@topic)
    else
      flash.now[:notice] = "Sorry, try again"
      render 'new'
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    @box_title = "Edit your topic"
    @subtitle  = "Settings"
    @placeholder_name = @topic.name
    @placeholder_description = @topic.description
  end

  def update
    @topic = Topic.find(params[:id])

    if @topic.update_attributes(topic_params)
      redirect_to topic_path @topic
    else
      flash[:notice] = "Sorry, try again"
      render 'edit'
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @room = @topic.room
    @topic.destroy

    redirect_to room_path @room
  end

  def update_current_slide
    send_slide params[:id], params[:slide_id], 'update_slide'
  end

  private

    def topic_params
      params.require(:topic).permit(:name, :description, :room_id, :slide)
    end

    def get_slide_questions_list(topic, slide_id)
      Question.where(topic: topic).group_by(&:slide_id)
    end
end
