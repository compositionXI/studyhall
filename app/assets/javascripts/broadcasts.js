$(document).ready(function() {
  if(typeof(current_user) == 'object') {
    if(typeof(Faye) == 'object') {
      var faye_client = new Faye.Client('http://app02.c45577.blueboxgrid.com:9292/faye');
      faye_client.subscribe('/broadcasts/user/' + current_user.id, function(serialized_data) {
        var data = $.parseJSON(serialized_data); 
        interpret_broadcast(data);
  	  });
      $("#notifications_queue").css("max-width", "1000px");
      $("#notifications_queue").css("width", "1000px");
    }
  }
});

interpret_broadcast = function(data) {
  var link;
  switch(data.intent) {
  case "studyhall_created" :
    link = "/study_sessions/" + data.args.id;
    break;
  case "message_sent" :
    link = "/messages/inbox";
    break;
  }

  var item = "<li><a href='" + link + "' id='notification-" + link + "' data-original-title>" + data.message + "</a></li><li class='divider'></li>";
  $("#notifications_queue").append(item);
}
