class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token if Rails.env.test?
	before_action :authenticate_member 
	before_action :show, :only => [:like]
	
	def index
		@questions = Question.all
	end

	def new
    @topic = Topic.find(params[:topic_id])
    @question = Question.new
    @box_title = "Create a question"
    @subtitle  = "Create"
    @placeholder_name = "Title"
    @placeholder_description = "Description"
    @url = topic_questions_path(@topic)
	end

  def new
    @topic = Topic.find(params[:topic_id])
    @question = Question.new
    @box_title = "Create a question"
    @subtitle  = "Create"
    @placeholder_name = "Title"
    @placeholder_description = "Description"
    @url = topic_questions_path(@topic)
  end

	def create
    @topic = Topic.find(params[:topic_id])

		@question = Question.new(question_params)
    @question.topic = @topic
    @question.member = current_member

		if @question.save
			redirect_to topic_path(@question.topic)
		else
			flash[:alert] = "Question not created"
      redirect_to new_topic_questions_path(@topic)
		end
	end

	def edit
    @question = Question.find(params[:id])
    @topic = @question.topic
    @box_title = "Edit your question"
    @subtitle  = "Settings"
    @placeholder_description = @question.content
    @url = question_path(@question)
	end

  def show
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])

    if params[:delete_attachment]
      delete_attachment @question
    end

    if @question.update_attributes(question_params)
      flash[:success] = "Questão atualizada com sucesso"
      redirect_to topic_path(@question.topic_id)
    else
      render 'edit'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @topic = @question.topic
    @question.destroy
    redirect_to topic_path(@topic)
	end

	def like
    @question.member = current_member
    if not current_member.voted_up_on? @question
      @question.like_by(current_member)
    else
      @question.disliked_by(current_member)
	  redirect_to :back
    end
	end

  def moderate_question
    question = Question.find(params[:id])
    @topic = question.topic
    if current_member == @topic.room.owner
      question.update_attributes(content: "This question has been moderated because it's content was considered inappropriate", moderated: true)
      redirect_to topic_path(@topic)
    else
      flash[:notice] = "You do not have permission!"
    end
  end

	private
		def question_params
			params.require(:question).permit(:content, :topic_id, :anonymous, :attachment)
		end

    def delete_attachment question
      question.attachment.destroy
    end

end
