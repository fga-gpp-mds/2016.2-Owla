class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'answers'
    stream_from 'questions'
  end
end
