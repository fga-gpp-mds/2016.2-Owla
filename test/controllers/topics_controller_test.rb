require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @member = Member.create(name: 'matheus',
                          email: 'matheus@gmail.com',
                          password: '123456',
                          password_confirmation: '123456',
                          alias: 'mateusin')

    @another_member = Member.create(name: 'joao',
                          email: 'joao@gmail.com',
                          password: '123456',
                          password_confirmation: '123456',
                          alias: 'joaovitor')

    @room = Room.create(name: 'teste', description: 'teste2', owner: @member)
    @topic = Topic.create(name: 'SomeTopic', description: 'somedescription', room: @room)

    sign_in_as @member
  end

  test "should get new" do
    get new_room_topic_path(@room)
    assert_response :success
  end

  test "should show topic" do
    get "/topics/#{@topic.id}"
    assert_response :success
  end

  test "should not show inexistent topic"  do
    get '/topics/show', params: {
      id: 12
    }

    assert_redirected_to home_path(@member)
    assert_equal "This topic does not exist", flash[:notice]
  end

  test "should create topic" do
    post "/rooms/#{@room.id}/topics", params: {
      topic: {
        name: "NewTopic",
        description: "somedescription"
      }
    }

    assert_redirected_to topic_path(Topic.last)
  end

  test "should not create topic with wrong information" do
    post "/rooms/#{@room.id}/topics", params: {
      topic: {
        name: "a",
        description: "a"
      }
    }

    assert_equal "Sorry, try again", flash[:notice]
  end

  test "should get edit topic page" do
    get "/topics/#{@topic.id}/edit"

    assert_response :success
  end

  test "should edit topic" do
    old_topic_name = @topic.name

    patch "/topics/#{@topic.id}", params: {
      topic: {
        name: "TopicName"
      }
    }

    @topic.reload

    assert_not_equal old_topic_name, @topic.name
  end

  test "should not edit topic if user is not its owner" do
    sign_out_as @member
    sign_in_as @another_member

    old_topic_name = @topic.name

    patch "/topics/#{@topic.id}", params: {
      topic: {
        name: "TopicName"
      }
    }

    @topic.reload

    assert_redirected_to topic_path(@topic)
    assert_equal old_topic_name, @topic.name
  end

  test "should not edit topic with wrong information" do
    old_topic_name = @topic.name

    patch "/topics/#{@topic.id}", params: {
      topic: {
        name: "a"
      }
    }

    @topic.reload

    assert_equal "Sorry, try again", flash[:notice]
  end

  test "should delete topic" do
    assert_difference('Topic.count', -1) do
      delete "/topics/#{@topic.id}"
      assert_redirected_to room_path(@room)
    end
  end

  test "should not delete topic if user is not its owner" do
    sign_out_as @member
    sign_in_as @another_member

    delete "/topics/#{@topic.id}"

    assert_redirected_to topic_path(@topic)
    assert_equal "You do not have permission to do this action", flash[:notice]
  end

  test "should user be able to see topic if he is joined in the respective room" do
    sign_out_as @member
    sign_in_as @another_member

    post '/rooms/signup', params: {
      id: @room.id
    }

    get topic_path(@topic)

    assert_response :success
  end

  test "should user not be able to see topic if he is not joined in the respective room" do
    sign_out_as @member
    sign_in_as @another_member

    @another_topic = Topic.create(name: 'AnotherTopic', description: 'somedescription', room: @room)

    get topic_path(@another_topic)

    assert_redirected_to home_path(@another_member)
  end
end
