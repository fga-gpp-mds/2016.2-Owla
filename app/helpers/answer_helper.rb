module AnswerHelper

  def send_cable answer, action
    html = ""

    if action == 'update_likes'
      html = render_like(answer)
    else
      html = render_answer(answer)
    end

    ActionCable.server.broadcast 'answers',
      action: action,
      html: html,
      question_id: answer.question.id,
      answer_id: answer.id,
      content: answer.content,
      question_answers_counter: answer.question.answers.count,
      answer_created_at: answer.created_at,
      answer_updated_at: answer.updated_at,
      answer_member: current_member.id,
      is_anonymous: answer.anonymous,
      likes: answer.get_likes.size
    head :ok
  end

  def render_answer answer
    ApplicationController.render({
      partial: 'answers/answer',
      locals: { answer: answer, room: answer.question.topic.room, current_member: current_member }
    })
  end

  def render_like answer
    ApplicationController.render({
      partial: 'likes/likes',
      locals: { url: like_answer_path(answer), object: answer }
    })
  end

end
