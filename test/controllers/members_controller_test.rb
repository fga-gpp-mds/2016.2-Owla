require 'test_helper'
include SessionsHelper

class MembersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @member = Member.create(name: 'matheus', 
                          email: 'matheus@gmail.com', 
                          password: '123456', 
                          password_confirmation: '123456', 
                          alias: 'mateusin')
    sign_in_as @member
  end

  test "should get new" do
    get '/members/new'
    assert_response :success
  end

  test "should create member" do
    post '/members', params: {
      member: {
        name: "matheus",
        email: "matheuss@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        alias: "membertest8"
      }
    }

    assert_redirected_to home_path Member.last
  end

  test "should show member" do
    get '/members/', params: {id: @member.id}
    assert_response :success
  end

  test "should not show member when member does not exist"  do

    get '/members/show', params: {id: 12}
    assert_response :missing
  end

  test "should fail to get details when is not logged" do
    sign_out_as @member

    get '/members/'
    assert_redirected_to root_path
  end

  test "should get edit member" do
    get "/members/#{@member.id}/edit"
    assert_response :success
  end

  test "should not get edit member when logged out" do
    sign_out_as @member
    get "/members/#{@member.id}/edit"
    assert_redirected_to root_path
  end

  test "should update member" do
    old_name = @member.name
    patch "/members/#{@member.id}", params: { member: {name: "joao",
                                        email: 'matheus@gmail.com',
                                        password: '123456',
                                        password_confirmation: '123456',
                                        alias: 'mateusin'} }
    @member.reload
    assert_not_equal old_name, @member.name

    assert_redirected_to members_path
  end

  test "should fail to update member when is not logged in" do
    sign_out_as @member

    patch "/members/#{@member.id}", params: { member: {name: "joao",
                                        email: 'matheus@gmail.com',
                                        password: '123456',
                                        password_confirmation: '123456',
                                        alias: 'mateusin'} }
    assert_redirected_to root_path
  end

  test "should delete member" do
    delete "/members/#{@member.id}"
    assert_redirected_to members_path
  end

  test "should not delete user if no one is logged in" do
    sign_out_as @member

    delete "/members/#{@member.id}"

    assert_redirected_to root_path
  end

# [TO DO: should not test CSS class]
#  test "should not delete member if does note exist" do
#    delete "/members/#{99}"
#
#    assert_response :missing
#  end

# [TO DO: should not test CSS class]
#  test "should not update member when missing param" do
#    patch "/members/#{@member.id}", params: { member: {name: "joao",
#                                        email: 'matheus@gmail.com',
#                                        password: '123456',
#                                        password_confirmation: '',
#                                        alias: 'mateusin'} }
#    assert_select '.alert'
#  end

# [TO DO: should not test CSS class]
#  test "should not create member" do
#    post '/members', params: {
#        member: {
#          name: "matheus",
#          email: "matheuss@gmail.com",
#          password: "123",
#          alias: "membertest8"
#        }
#      }
#    assert_select '.notice'
#  end

end
