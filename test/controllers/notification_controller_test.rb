require 'test_helper'
include SessionsHelper

class NotificationControllerTest < ActionDispatch::IntegrationTest

  def setup
    @member = Member.create(name: 'vitor', email: 'vitor@gmail.com', alias: 'vitor', password: '12345678', password_confirmation: '12345678')
    @member2 = Member.create(name: 'victor', email: 'victor@gmail.com', alias: 'victor', password: '12345678', password_confirmation: '12345678')
    sign_in_as @member

    @room = Room.create(name: "calculo 1", description: "teste1", owner: @member)
    @topic = @room.topics.create(name: "limites", description: "description1")

    @question = @topic.questions.create(content: "How did I get here?", member: @member)
    @question_member_2 = @topic.questions.create(content: "How did I get here?", member: @member2)

    @answer = @question.answers.create(content: "CONTENT TEST", member: @member)
    @answer_member_2 = @question.answers.create(content: "CONTENT TEST", member: @member2)
  end

  test "should create notification when user signs up" do
    sign_out_as @member

    assert_difference('Notification.count') do
      post "/members", params: {
        member: {
          name: "User Test",
          email: "user@gmail.com",
          alias: "usertest",
          password: "12345678",
          password_confirmation: "12345678"
        }
      }
    end

    created_member = current_member

    assert created_member.received_notifications.count, 1
    assert created_member.received_notifications.last.message, "Welcome to Owla!"
  end

  test "should user be notified someone answer his question" do
    user_notifications_counter = @question.member.received_notifications.count

    assert_difference('Notification.count') do
      post "/questions/#{@question.id}/answers", params: {
        answer: {
          content: "Resposta da pergunta"
        }
      }
    end

    assert_equal user_notifications_counter, @question.member.received_notifications.count - 1
  end

  test "should room owner be notified when someone creates a question in a topic in his room" do
    owner = @room.owner
    owner_notifications_counter = owner.received_notifications.count

    sign_out_as @member
    sign_in_as @member2

    assert_difference('Notification.count') do
      post "/topics/#{@topic.id}/questions", params: {
        question: {
          content: "How did I get here?",
        }
      }
    end

    assert_equal owner_notifications_counter, owner.received_notifications.count - 1
  end

  test "should user be notified when his question is moderated" do
    member_2_notification_counter = @member2.received_notifications.count

    assert_difference('Notification.count') do
      post "/moderate_question/#{@question_member_2.id}"
    end

    assert_equal member_2_notification_counter, @member2.received_notifications.count - 1
  end

  test "should user be notified when his answer is moderated" do
    member_2_notification_counter = @member2.received_notifications.count

    assert_difference('Notification.count') do
      post "/moderate_answer/#{@answer_member_2.id}"
    end

    assert_equal member_2_notification_counter, @member2.received_notifications.count - 1
  end

  test "should room owner be notified when a question in a topic of his room is reported" do
    owner = @room.owner
    owner_notifications_counter = owner.received_notifications.count

    assert_difference('Notification.count') do
      post "/report_question/#{@question_member_2.id}"
    end

    assert_equal owner_notifications_counter, owner.received_notifications.count - 1
  end

  test "should room owner be notified when a answer in a topic of his room is reported" do
    owner = @room.owner
    owner_notifications_counter = owner.received_notifications.count

    assert_difference('Notification.count') do
      post "/report_answer/#{@answer_member_2.id}"
    end

    assert_equal owner_notifications_counter, owner.received_notifications.count - 1
  end

  test "should room owner be notified when someone joins his room" do
    owner = @room.owner
    owner_notifications_counter = owner.received_notifications.count

    sign_out_as @member
    sign_in_as @member2

    assert_difference('Notification.count') do
      post "/rooms/signup", params: {
        id: @room.id
      }
    end

    assert_equal owner_notifications_counter, owner.received_notifications.count - 1
  end

  %w[question answer].each do |word|
    test "should user be notified when someone likes his #{word}" do
      sign_out_as @member
      sign_in_as @member2

      member_notification_counter = @member.received_notifications.count

      assert_difference('Notification.count') do
        word_object = eval("@#{word}")
        post "/#{word.pluralize}/#{word_object.id}/like"
      end

      assert_equal member_notification_counter, @member.received_notifications.count - 1
    end
  end

end
