App.messages = App.cable.subscriptions.create('AnswersChannel', {
  received: function(data) {
    if (data.action === 'create_answer'){
      return this.createMessage(data);
    }
    else if (data.action === 'update_answer'){
      return this.updateMessage(data);
    }
    else if (data.action === 'delete_answer'){
      return this.deleteMessage(data);
    }
    else if (data.action === 'update_likes'){
      return this.updateLikes(data);
    }
  },

  createMessage: function(data) {
    var currentMemberId = getCookie("member_id");
    var roomOwnerId     = getCookie("room_owner_id");

    $("#box-question-" + data.question_id).removeClass('hidden');
    $('.content-text').val('');
    this.updateQuestionCounter(data);
    $("#box-question-" + data.question_id).append(data.html);

    if (currentMemberId != data.answer_member){
      $("#edit-answer-" + data.answer_id).hide();
      $("#delete-answer-" + data.answer_id).hide();

      if(data.is_anonymous && roomOwnerId != currentMemberId){
        this.turnAnonymous(data);
      }
    }

    return true;
  },

  updateMessage: function(data) {
    if(data.answer_created_at !== data.answer_updated_at){
      $('#answer-' + data.answer_id + '-datetime .edited').removeClass('hidden');
    }
    return $("#answer-content-" + data.answer_id).html(data.content);
  },

  deleteMessage: function(data) {
    this.updateQuestionCounter(data);
    return $("#box-answer-" + data.answer_id).hide();
  },

  updateQuestionCounter: function(data) {
    return $("#question-answers-counter-" + data.question_id).html(data.question_answers_counter);
  },

  turnAnonymous: function(data) {
    $("#box-answer-" + data.answer_id + " #username").html('Anonymous');
    $("#box-answer-" + data.answer_id + " .user-image").attr('src', '/images/missing.png');
  },

  updateLikes: function(data) {
    $("#answer-like-" + data.answer_id).html(data.likes);
  }
});
