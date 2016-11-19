require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @member = Member.create(name: "Thalisson", alias: "thalisson", email: "thalisson@gmail.com", password: "12345678", password_confirmation: "12345678")
    @member_wrong = Member.create(name: "Thalisson2", alias: "thalisson2", email: "thalisson2@gmail.com", password: "12345678", password_confirmation: "12345678")

    @room = Room.create(name: "calculo 1", description: "teste1", owner: @member)
    @room_wrong = Room.create(name: 'calc2', description: 'teste2', owner: @member_wrong)

    @topic = @room.topics.create(name: "limites", description: "description1")
    @topic_wrong = @room_wrong.topics.create(name: 'edo', description: 'teste2')

    @question = @topic.questions.create(content: "How did I get here?", member: @member)

    attachment = fixture_file_upload('test/fixtures/sample_files/file.png', 'image/png')

    @answer = @question.answers.create(content: "CONTENT TEST", member: @member, attachment: attachment)

    sign_in_as @member
  end

   test "should create answer" do
     post question_answers_path(@question), params: {
       answer: {
         content: "Resposta da pergunta"
       }
     }
     assert_response :success
   end

   test "should edit answer" do
     answer_id = @answer.id
     answer_content = @answer.content
     patch "/answers/#{answer_id}", params: {
       answer: { content: "verdadeira resposta da pergunta" }
     }

     @answer.reload

     assert_not_equal answer_content, @answer.content
   end

   test "should not edit answer when member is not logged in" do
    sign_out_as @member
    answer_id = @answer.id
    answer_content = @answer.content
    patch "/answers/#{answer_id}", params: {
      answer: { content: "verdadeira resposta da pergunta?" }
    }

    @answer.reload

    assert_equal answer_content, @answer.content
  end

  test "should delete answer" do
    assert_difference('Answer.count', -1) do
      delete "/answers/#{@answer.id}"
      assert_response :success
    end
  end

  test "should not delete the answer if user is not logged in" do
    sign_out_as @member
    delete "/answers/#{@answer.id}"
    assert_redirected_to root_path
  end

  test "Should appear as anonymous user if the member isn't the room owner" do
    @answer.anonymous = true
    answer_name = @answer.member.name
    member_id = 2

    if (@answer.anonymous && @room.owner != member_id)
      @answer.member.name = "Usuário anônimo"
    end
  end

  test "Should appear as anonymous user if the member isn't the answer owner" do
    @answer.anonymous = true
    answer_name = @answer.member.name
    member_id = 2

    if (@answer.anonymous && @answer.member.id != member_id)
      @answer.member.name = "Usuário anônimo"
    end
  end

  test "should appear as anonymous user when answer if the member isn't the room owner and the question owner" do
    @answer.anonymous = true
    member_id = 2
    answer_name = @answer.member.name

    if (@answer.anonymous && @room.owner.id != member_id && member_id != @answer.member.id)
      @answer.member.name = "Usuário Anônimo"
    end

    assert_not_equal answer_name, @answer.member.name
  end

  test "should not appear as anonymous user when answer if the member is the room owner" do
    answer_name = @answer.member.name

    if (@answer.anonymous && @room.owner.id != @member.id)
      @answer.member.name = "Usuário anônimo"
    end

    assert_equal answer_name, @answer.member.name
  end

  test "should not appear as anonymous user when answer if the member is the question owner" do
    answer_name = @answer.member.name

    if (@answer.anonymous && @room.owner.id != @member.id && @member.id != @answer.member.id)
      @answer.member.name = "Usuário anônimo"
    end

    assert_equal answer_name, @answer.member.name
  end

  test "should not appear as anonymous user when answer if the member is the room owner and the question owner" do
    answer_name = @answer.member.name

    if (@answer.anonymous && @room.owner.id != @member.id && @member.id != @answer.member.id)
      @answer.member.name = "Usuário anônimo"
    end

    assert_equal answer_name, @answer.member.name
  end

  test "answer should have one like after button click" do
    post "/answers/#{@answer.id}/like"
    assert_equal 1, @answer.votes_for.size
  end

  test "boolean attribute for answer should change" do 
    post "/answers/#{@answer.id}/like"
    assert @answer.liked_by(@member), true
  end

  test 'only room owner should change moderated attribute of an answer' do
    @not_owner_member = Member.create(name: "Thalisson2", alias: "thalisson2", email: "thalisson2@gmail.com", password: "123456789", password_confirmation: "123456789")
    sign_out_as @member
    sign_in_as @not_owner_member
    post "/moderate_answer/#{@answer.id}"
    @answer.reload
    assert_not_equal true, @answer.moderated
  end

  test 'only room owner should change content of a moderated answer' do
    @not_owner_member = Member.create(name: "Thalisson2", alias: "thalisson2", email: "thalisson2@gmail.com", password: "123456789", password_confirmation: "123456789")
    sign_out_as @member
    sign_in_as @not_owner_member
    post "/moderate_answer/#{@answer.id}"
    @answer.reload
    assert_not_equal "This answer has been moderated because it's content was considered inappropriate", @answer.content
  end

  test 'should change the message after moderating' do
    post "/moderate_answer/#{@answer.id}"
    @answer.reload
    assert_equal "This answer has been moderated because it's content was considered inappropriate", @answer.content
  end

  test 'boolean attribute moderated should change after moderated' do
    post "/moderate_answer/#{@answer.id}"
    @answer.reload
    assert_equal true, @answer.moderated
  end

  test "should upload attachment when answer is created" do
    attachment = fixture_file_upload('test/fixtures/sample_files/file.png', 'image/png')

    assert_difference('Answer.count') do
      post "/questions/#{@question.id}/answers", params: {
        answer: {
          content: "Answer test",
          attachment: attachment
        }
      }
    end

  end

  test "should not upload wrong type of attachment" do
    wrong_attachment = fixture_file_upload('test/fixtures/answers.yml', 'application/yaml')

    old_answer = Answer.last

    post "/questions/#{@question.id}/answers", params: {
      answer: {
        content: "Testing wrong attachment",
        attachment: wrong_attachment
      }
    }

    assert_equal old_answer, Answer.last
  end

  test "should delete attachment from answer if option is marked" do
    answer = Answer.last

    patch "/answers/#{answer.id}", params: {
      answer: {
        content: "new question content"
      },
      delete_attachment: true
    }

    answer.reload

    assert_not answer.attachment?
  end

  test "should not delete attachment if option is not marked" do
    answer = Answer.last

    patch "/answers/#{answer.id}", params: {
      answer: {
        content: "new question content"
      }
    }

    answer.reload

    assert answer.attachment?
  end

  test 'should answer be anonymous if the option is marked' do
    post "/questions/#{@question.id}/answers", params: {
      answer: {
        content: 'answer content',
        anonymous: true
      }
    }

    answer = Answer.last

    assert_equal answer.anonymous, true
  end

  test 'should answer not be anonymous if the option is not marked' do
    post "/questions/#{@question.id}/answers", params: {
      answer: {
        content: 'answer content'
      }
    }

    answer = Answer.last

    assert_not_equal answer.anonymous, true
  end
  
end
