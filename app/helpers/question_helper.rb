module QuestionHelper

  def send_question question, action
    html = ""

    if action == 'update_likes'
      html = render_like(question)
    else
      html = render_question(question)
    end

    ActionCable.server.broadcast 'questions',
      action: action,
      html: html,
      question_id: question.id,
      topic_id: question.topic.id,
      content: question.content,
      slide_id: question.slide_id,
      likes: question.get_likes.size
    head :ok
  end

  def render_question question
    ApplicationController.render({
      partial: 'questions/question',
      locals: { question: question, room: question.topic.room, new_answer: Answer.new, current_member: question.member}
    })
  end

  def render_like question
    ApplicationController.render({
      partial: 'likes/likes',
      locals: { url: like_question_path(question.id), object: question }
    })
  end

end
