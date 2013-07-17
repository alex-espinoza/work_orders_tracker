var show_ajax_message = function(msg, type) {
  $("#flash-message").html("<div class='alert alert-success' id='flash-" + type + "'>" + msg + "</div>");
  $(".alert.alert-success").hide()
  return $("#flash-" + type).show().delay(5000).slideUp('slow');
};

$(document).ajaxComplete(function(event, request) {
  var msg, type;
  msg = request.getResponseHeader("X-Message");
  type = request.getResponseHeader("X-Message-Type");
  if (msg != null) {
    return show_ajax_message(msg, type);
  }
});
