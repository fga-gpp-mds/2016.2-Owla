require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  def setup
    @member = Member.create(name: "Linus Torvalds", alias: "Lineu", email: "linuxFTW@linux.com", password: "i<3linux", password_confirmation: "i<3linux")
    @room = Room.create(name: "c1", description: "-"*2, owner: @member)
    @topic = @room.topics.create(name: "Limite", description: "example description")
    @file = File.new('test/fixtures/sample_files/file.pdf')
  end

  test "should not save a question with a null name" do
    @question = @topic.questions.new(content: nil, member: @member)
    assert_not @question.save
  end

  test "should not save a question with content smaller than 5 characters" do
    @question = @topic.questions.new(content: "1234", member: @member)
    assert_not @question.save
  end

  test "should save a question with exactly 5 characters" do
    @question = @topic.questions.new(content: "12345", member: @member)
    assert @question.save
  end

  test "should not save a question without a topic" do
    @invalid = Question.new(content: "1+1=3?", member: @member)
    assert_not @invalid.save
  end

  test "should not save a question without an author" do
    @invalid = Question.new(content: "Rails > Java?")
    assert_not @invalid.save
  end

  test "should create a not null question" do
    @question = @topic.questions.new(content: "What is love?", member: @member)
    assert_not_nil @question
  end

  test "should change content when question is edited" do
    @question = @topic.questions.new(content: "What is love?", member: @member)
    assert @question
    before_content = @question.content
    @question.update_attribute(:content,"Is this the real life?")
    after_content = @question.content
    assert_not_equal before_content,after_content
  end

  test "should delete question" do
    @question = @topic.questions.create(content: "What is love?", member: @member)
    question_id = @question.id
    count_before = Question.count
    @question.destroy
    recovered_question = Question.where(:id => question_id)
    count_after = Question.count
    assert_equal recovered_question.count, 0
    assert_equal count_before,count_after+1
  end

  test "should anonymous option be unchecked by default" do
    q = Question.new
    assert_equal false, q.anonymous
  end

  test "should save question with no attachment" do
    question = @topic.questions.new(content: "What is love?", member: @member)
    assert question.save

    question = @topic.questions.new(content: "What is love?", member: @member, attachment: "")
    assert question.save
  end

  test "should save question with an attachment" do
    question = @topic.questions.new(content: "What is love?", member: @member, attachment: @file)
    assert question.save
  end

  test "should save question with correct type of attachment" do
    %w[docx jpeg jpg odp ods odt pdf png ppt pptx xls xlsx].each do |extension|
      file = File.new("test/fixtures/sample_files/file.#{extension}")
      question = @topic.questions.new(content: "What is love?", member: @member, attachment: file)
      assert question.save
    end
  end

  test "should not save question with wrong type of attachment" do
    another_file = File.new('test/fixtures/answers.yml')
    question = @topic.questions.new(content: "What is love?", member: @member, attachment: another_file)
    assert_not question.save
  end

  # FIXME download

end
