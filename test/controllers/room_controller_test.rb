require 'test_helper'

class RoomControllerTest < ActionDispatch::IntegrationTest

  def setup
    @member = Member.create(name: 'matheus',
                          email: 'matheus@gmail.com',
                          password: '123456',
                          password_confirmation: '123456',
                          alias: 'mateusin')
    @room = Room.new(name: 'teste', description: 'teste2')
    @room.owner = @member
    @room.save
    @topic = Topic.new(name: 'SomeTopic', description: 'somedescription')
    @topic.room = @room
    @topic.save
    sign_in_as @member
  end

  test "should get index" do
    get member_rooms_path(@member)
    assert_response :success
  end

  test "should not get index if not logged in" do
    sign_out_as @member
    get member_rooms_path(@member)
    assert_redirected_to root_path
  end

  test "should get new" do
    get new_member_room_path(@member)
    assert_response :success
  end

  test "should not get new if not logged in" do
    sign_out_as @member
    get new_member_room_path(@member)
    assert_redirected_to root_path
  end

  test "should create room" do
    post  "/members/#{@member.id}/rooms/", params: { room: { name: "teste", description: "testedescription" } }
    assert_redirected_to room_path(@member.my_rooms.last)
  end

  test "should not create room when missing name" do
    post "/members/#{@member.id}/rooms/", params: { room: { name: '' } }
    assert_redirected_to new_member_room_path(@member)
  end

  test "should get edit room" do
    get edit_room_path(@room)
    assert_response :success
  end

  test "should update room" do
    name_old = @room.name
    patch "/rooms/#{@room.id}", params: {room: { name: "teste2" } }
    @room.reload

    assert_not_equal name_old, @room.name
    assert_redirected_to "/rooms/#{@room.id}"
  end

  test "should destroy room" do
    assert_difference('Room.count', -1) do
      delete "/rooms/#{@room.id}"
      assert_redirected_to  member_rooms_path(@member)
    end
  end

  test "should user be in room's black_list if owner bans him" do
      @member2 = Member.create(name: 'matheuss', email: 'matheuss@gmail.com', password: '123456', password_confirmation: '123456', alias: 'mateusisn')
      @member2.rooms << @room
      @member2.save

      post "/topics/#{@topic.id}/ban_member", params: {member_id: @member2.id, topic_id: @topic.id}
      @room.reload

      assert @room.black_list.include? @member2.id
  end

  test "should user not be banned by another regular user" do
      @member2 = Member.create(name: 'matheuss', email: 'matheuss@gmail.com', password: '123456', password_confirmation: '123456', alias: 'mateusisn')
      @member3 = Member.create(name: 'matheusss', email: 'matheusss@gmail.com', password: '12345678', password_confirmation: '12345678', alias: 'mateussisn')
      @member2.rooms << @room
      @member3.rooms << @room
      @member2.save
      @member3.save
      sign_out_as @member
      sign_in_as @member2
      post "/topics/#{@topic.id}/ban_member", params: {member_id: @member3.id, topic_id: @topic.id}
      @room.reload

      assert_not @room.black_list.include? @member3.id
  end

  test "should member not enter room if he is in it's blacklist" do
    @member2 = Member.create(name: 'matheuss', email: 'matheuss@gmail.com', password: '123456', password_confirmation: '123456', alias: 'mateusisn')
    @member2.rooms << @room
    post "/topics/#{@topic.id}/ban_member", params: {member_id: @member2.id, topic_id: @topic.id}
    sign_out_as @member
    sign_in_as @member2
    post "/rooms/signup", params: {id: @room.id}

    assert_equal "You are not allowed to join this room", flash[:notice]
    assert_not @room.members.include? @member2
  end

  test "should owner be able to reintegrate someone who is in black list" do
    @member2 = Member.create(name: 'matheuss', email: 'matheuss@gmail.com', password: '123456', password_confirmation: '123456', alias: 'mateusisn')
    @member2.rooms << @room
    post "/topics/#{@topic.id}/ban_member", params: {member_id: @member2.id, topic_id: @topic.id}
    post "/rooms/#{@room.id}/reintegrate_member", params: {id: @room.id, member_id: @member2.id}
    @room.reload

    assert_not @room.black_list.include? @member2
    assert_equal "Member has been removed from black list and can now join the room", flash[:notice]
    assert_redirected_to banned_members_url
  end

  test "should member enter room if he is reintegrated" do
    @member2 = Member.create(name: 'matheuss', email: 'matheuss@gmail.com', password: '123456', password_confirmation: '123456', alias: 'mateusisn')
    @member2.rooms << @room
    post "/topics/#{@topic.id}/ban_member", params: {member_id: @member2.id, topic_id: @topic.id}
    post "/rooms/#{@room.id}/reintegrate_member", params: {id: @room.id, member_id: @member2.id}
    sign_out_as @member
    sign_in_as @member2
    post "/rooms/signup", params: {id: @room.id}

    assert @room.members.include? @member2
  end

  test "should get banned members" do
    get banned_members_url @room
    assert_response :success
  end


end
