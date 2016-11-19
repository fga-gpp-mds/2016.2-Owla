App.questionChannel = App.cable.subscriptions.create('QuestionsChannel', {
  received: function(data) {
    if (data.action === 'create_question'){
      return this.createQuestion(data);
    }
    else if (data.action === 'update_question'){
      return this.updateQuestion(data);
    }
    else if (data.action === 'delete_question'){
      return this.deleteQuestion(data);
    }
    else if (data.action === 'update_slide'){
      // console.log("ENTRRRROU");
      return this.updateCurrentSlide(data);
    }
    else if (data.action === 'update_likes'){
      return this.updateLikes(data);
    }
  },

  createQuestion: function(data) {
    if(data.slide_id){
      return $("#slide-" + data.slide_id)
             .find("#topic-question-box-" + data.topic_id)
             .append(data.html);
    } else {
      return $("#topic-question-box-" + data.topic_id)
             .append(data.html);
    }
  },

  updateQuestion: function(data) {
    return $("#question-" + data.question_id)
           .find(".question-content")
           .html(data.content);
  },

  deleteQuestion: function(data) {
   // this.updateQuestionCounter(data);
   // return $("#box-answer-" + data.answer_id).hide();
  },

  updateCurrentSlide: function(data){
    if($("#carousel-slide[topic='" + data.topic_id + "'].following").length){
      $("#carousel-slide[topic='" + data.topic_id + "'].following").carousel(parseInt(data.slide_id));
      $("#father-topic-" + data.topic_id).find("#hidden-slide-id").attr('value', data.slide_id);
    }
  },

  updateLikes: function(data) {
    $("#question-like-" + data.question_id).html(data.likes);
  }
});
