class QuestionsController < ApplicationController
  include QuestionHelper
  skip_before_action :verify_authenticity_token if Rails.env.test?
  before_action :authenticate_member
  before_action :show, :only => [:like]

  def index
    @questions = Question.all
  end

  def new
  end

  def show
    @question = Question.find(params[:id])
  end

  def create
    @topic = Topic.find(params[:topic_id])

    @question = Question.new(question_params)
    @question.topic = @topic
    @question.member = current_member
    set_slide_id(@question, params[:slide_id])

    if @question.save
      send_notification('created_question', @question)
      send_question @question, 'create_question'
    end
  end

  def edit
  end

  def update
    @question = Question.find(params[:id])
    @topic = @question.topic

    if params[:delete_attachment]
      delete_attachment @question
    end

    if @question.update_attributes(question_params)
      if @topic.slide.present?
        set_slide_id(@question, params[:slide_id])
      end

      send_question @question, 'update_question'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @topic = @question.topic
    @question.destroy
    redirect_to topic_path(@topic)
  end

  def like
    unless current_member.voted_up_on? @question
      @question.like_by(current_member)

      if @question.member != current_member
        send_notification('liked_question', @question)
      end
    else
      @question.disliked_by(current_member)
    end

    send_question @question, 'update_likes'
  end

  def moderate_question
    question = Question.find(params[:id])
    @topic = question.topic
    if current_member == @topic.room.owner
      question.update_attributes(
        content: "This question has been moderated because it's content was considered inappropriate",
        moderated: true)

      send_notification("moderated_question", question)

      redirect_to topic_path(@topic)
    else
      flash[:notice] = "You do not have permission!"
    end
  end

  def report_question
      member = current_member
      @question = Question.find(params[:id])

      @topic = @question.topic
      @room = @topic.room
      @report = Report.new(moderator: @room.owner, reported: @question.member, question: @question)
      @report.members << current_member

      if @report.save
        flash[:alert] = "Your report was submitted"  
        send_notification("reported_question", @question)

        redirect_to topic_path(@topic)
      else
        flash[:alert] = "Report not created"
        redirect_to topic_path(@topic)
      end      
    end

	private
    
    def check_question
      member = current_member
      @question = Question.find(params[:id])

      if (@question.report.blank? == false) && @question.report.members.include?(member)
        flash[:alert] = "You have already reported this user"
        redirect_to topic_path(@question.topic.id)
      end
    end

    def question_params
      params.require(:question).permit(:content,
                                       :topic_id,
                                       :anonymous,
                                       :slide_id,
                                       :attachment)
    end

    def delete_attachment question
      question.attachment.destroy
    end

    def set_slide_id(question, slide_id)
      question.slide_id = slide_id
    end
end
