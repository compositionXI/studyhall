var hide_message = function(selector){
  $("#"+selector).delay(400).slideUp(1000);
}

$(document).ready(function(){
  $("body").delegate("a.cancel_message","click",function(e){
    $("#new_message_button").popover("hide");
    e.preventDefault();
  });
});
