$(document).ready(function() {
  var faye_client = new Faye.Client('http://localhost:9292/faye');
  faye_client.subscribe('/notifications/push', function(data) {
    $("#notifications_queue").append(data);
	});
  $("#notifications_queue").css("width", "200px");
});
