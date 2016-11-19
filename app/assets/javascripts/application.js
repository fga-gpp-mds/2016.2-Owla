// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= stub cable
//= require admin_lte/admin_lte
//= require bootstrap-switch
//= require bootstrap-wysihtml5
//= require bootstrap-wysihtml5/locales
//= require turbolinks

$(document).ready(function(){
  $('#notification-dropdown').click(function(){
    $('#notification-counter').hide();
  });

  $('#edit-attachment-button').click(function(){
    $('#question-attachment-link').toggleClass('hidden');
    $('#answer-attachment-link').toggleClass('hidden');
    $('#delete-attachment-label').toggleClass('hidden');
  });
});

// Customize text editor
$(function () {
  $(".textarea").wysihtml5();
});

// Close modal on submit
$('.modal-form').on('submit', function() {
  $('.modal').modal('hide');
});

//Static slide
$("#carousel-slide").carousel({interval: false});

//Slide id


$('a[data-slide="prev"]').click(function() {
  var slideSize = getSlideSize(); 
  var previousSlideId = getCurrentSlide();
  var currentSlideId = normalizeSlideId(decrement, previousSlideId, slideSize);
  $("#father-topic-" + getTopicId()).find("#hidden-slide-id").attr('value', currentSlideId);
  sendSlide(currentSlideId);
});

$('a[data-slide="next"]').click(function() {
  var slideSize = getSlideSize(); 
  var previousSlideId = getCurrentSlide();
  var currentSlideId = normalizeSlideId(increment, previousSlideId, slideSize);
  $("#father-topic-" + getTopicId()).find("#hidden-slide-id").attr('value', currentSlideId);
  sendSlide(currentSlideId);
});

function getSlideSize(){
  return $('#carousel-slide').attr('size');
}

function getCurrentSlide(){
  var re = /slide-(\d+)/;
  return $('.item.active').attr('id').match(re)[1];
}

function normalizeSlideId(func, previous, limit){
  limit = parseInt(limit);
  previous = parseInt(previous);

  var normalizedId = func(previous);
  if(normalizedId < 0)
    normalizedId = limit - 1;
  else if(normalizedId >= limit)
    normalizedId = 0;

  return normalizedId;
}

function increment(id){
  return parseInt(id) + 1;
}

function decrement(id){
  return parseInt(id) - 1;
}

function getTopicId(){
  var re = /father-topic-(\d+)/;
  var id = $("[name='father']").attr('id').match(re)[1];
  console.log(id);
  return id;
}

function sendSlide(slideId){
  var currentMemberId = getCookie("member_id");
  var roomOwnerId     = getCookie("room_owner_id");

  if(currentMemberId === roomOwnerId){
    var currentTopicId = getTopicId();
    var url = "/topics/" +  currentTopicId + "/slide/" + slideId;
    $.ajax({
      type: "POST",
      url: url,
    });
  }
}

// Initialize bootstrap switch
$("[name='follow-slide']").bootstrapSwitch();

$('input[name="follow-slide"]').on('switchChange.bootstrapSwitch', function(event, state) {
  if(state){
    $("#carousel-slide[topic='" + getTopicId() + "']").addClass("following");
  } else {
    $("#carousel-slide[topic='" + getTopicId() + "']").removeClass("following");
  }
});
