require 'test_helper'

class TagTest < ActiveSupport::TestCase

  def setup
    @member = Member.create(name: "Linus Torvalds", alias: "Lineu", email: "linuxFTW@linux.com", password: "i<3linux", password_confirmation: "i<3linux")
    @room = Room.create(name: "c1", description: "-"*2, owner: @member)
    @topic = @room.topics.create(name: "limit", description: "example description")
    @question = @topic.questions.create(content: "Is there a limit?", member: @member)
    @tag = @question.tags.create(content: "test", member: @member)
  end 

  test "should save valid tag" do
    assert @tag.save
  end 

  test "should not save empty tag" do
    @invalid_tag = @question.tags.create(content: "", member: @member)
    assert_not @invalid_tag.save
  end

  test "should not save a tag without an author" do
    @tag = Tag.new(content: "Orphan tag")
    assert_not @tag.save
  end

  test "should not save tags with less than two letters content" do
    @invalid_tag = @question.tags.create(content: "a", member: @member)
    assert_not @invalid_tag.save
  end

  test "should not save tags with more than twenty five letters content" do
    @invalid_tag = @question.tags.create(content: "a"*26, member: @member)
    assert_not @invalid_tag.save
  end 

  test "should save a tag with exactly two or twenty five letters content" do
  	@valid_tag1 = @question.tags.create(content: "a"*2, member: @member)
    assert @valid_tag1.save
    @valid_tag2 = @question.tags.create(content: "a"*25, member: @member)
    assert @valid_tag2.save
  end

  test "should create not null tag" do
    assert_not_nil @tag
  end


  test "should change name when tag is edited" do
    before = @tag.content
    @tag.update_attribute(:content,"Cálculo 2")
    after = @tag.content
    assert_not_equal before,after
  end

  test "should delete tag" do
      tag_id = @tag.id
      count_before = Tag.all.count
      @tag.destroy
      recovered_tag = Tag.where(:id => tag_id)
      count_after = Tag.all.count
      assert_equal recovered_tag.count, 0
      assert_equal count_before,count_after+1
  end
end
