// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

function getCookie(cookie_key) {
  var cookie_value = " " + document.cookie;
  var cookie_start = cookie_value.indexOf(" " + cookie_key + "=");
  if (cookie_start == -1) {
    cookie_value = null;
  }
  else {
    cookie_start = cookie_value.indexOf("=", cookie_start) + 1;
    var cookie_end = cookie_value.indexOf(";", cookie_start);
    if (cookie_end == -1) {
      cookie_end = cookie_value.length;
    }
    cookie_value = unescape(cookie_value.substring(cookie_start,cookie_end));
  }
  return cookie_value;
}

(function() {
  this.App || (this.App = {});
  App.cable = ActionCable.createConsumer();
}).call(this);
