require 'test_helper'

class NotificationTest < ActiveSupport::TestCase

  def setup
    @sender = Member.create(name: "Linus Torvalds", alias: "Lineu", email: "linuxFTW@linux.com", password: "i<3linux", password_confirmation: "i<3linux")
    @receiver = Member.create(name: "Member test", alias: "test", email: "test@test.com", password: "testtest", password_confirmation: "testtest")
    @notification = Notification.new(message: "New Notification", sender: @sender, receiver: @receiver)
  end

  test "should save valid notification" do
  	assert @notification.save
  end

  test "should not save notification with empty message" do
    @notification.message = ""
    assert_not @notification.save
  end

  test "should not save notification with message smaller than 5 characters" do
    @notification.message = "-"
    assert_not @notification.save
  end

  test "should not save notification with message bigger than 255 characters" do
    @notification.message = "-" * 300
    assert_not @notification.save
  end

  test "should save notification when the message has exactly 5 or 255 characters" do
    @notification.message = "-" * 5
    assert @notification.save
    @notification.message = "-" * 255
    assert @notification.save
  end

  test "attribute 'read' should be false by default" do
    @new_notification = Notification.new
    assert_equal false, @new_notification.read
  end

  test "should save notification with 'read' attribute true" do
    @valid = Notification.new(message: "-" * 5, read: true, receiver: @receiver)
    assert @valid.save
  end

  test "should save notification with no sender" do
    @notification.sender = nil
    assert @notification.save
  end

end
