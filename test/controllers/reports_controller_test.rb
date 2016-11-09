require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @member = Member.create(name: "Thalisson", alias: "thalisson", email: "thalisson@gmail.com", password: "12345678", password_confirmation: "12345678")
    @member2 = Member.create(name: "thalisson2", alias: "thalisson2", email: "thalisson2@gmail.com", password: "12345678", password_confirmation: "12345678")
    @member3 = Member.create(name: "thalisson3", alias: "thalisson3", email: "thalisson3@gmail.com", password: "12345678", password_confirmation: "12345678")

    @room = Room.new(name: "calculo 1", description: "teste1")
    @room.owner = @member
    @room.save

    @topic = @room.topics.new(name: "limites", description: "description1")
    @topic.save

    @question = @topic.questions.new(content: "How did I get here?")
    @question.member = @member2
    @question.save

    @answer = Answer.new(content: "CONTENT TEST")
    @answer.member = @member3
    @answer.question = @question
    @answer.anonymous = false
    @answer.save

    @report = Report.create(explanation: "Inappropriate content")
  end

  test 'should create report for question' do
    sign_in_as @member3

    count_before = Report.count
    post report_question_path(@question), params: {id: @question.id}
    count_after = Report.count

    assert count_after, count_before+1
    assert_redirected_to topic_path(@topic)
  end

  test 'should not create report for question when not logged in' do
    count_before = Report.count
    post report_question_path(@question), params: {id: @question.id}
    count_after = Report.count

    assert count_after, count_before
    assert_redirected_to root_path
  end

  test 'should not create report for question when member already reported' do
    sign_in_as @member3
    post report_question_path(@question), params: {id: @question.id}

    count_before = Report.count
    post report_question_path(@question), params: {id: @question.id}
    count_after = Report.count

    assert count_after, count_before
    assert_redirected_to topic_path(@topic)
  end

    test 'should create report for answer' do
    sign_in_as @member2

    count_before = Report.count
    post report_answer_path(@answer), params: {id: @answer.id}
    count_after = Report.count

    assert count_after, count_before + 1
    assert_redirected_to topic_path(@topic)
  end

  test 'should not create report for answer when not logged in' do
    count_before = Report.count
    post report_answer_path(@answer), params: {id: @answer.id}
    count_after = Report.count

    assert count_after, count_before
    assert_redirected_to root_path
  end

  test 'should not create report for answer when member already reported' do
    sign_in_as @member2
    post report_answer_path(@answer), params: {id: @answer.id}

    count_before = Report.count
    post report_answer_path(@answer), params: {id: @answer.id}
    count_after = Report.count

    assert count_after, count_before
    assert_redirected_to topic_path(@topic)
  end
end
