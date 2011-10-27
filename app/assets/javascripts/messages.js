var hide_message = function(selector){
  $("#"+selector).delay(400).slideUp(1000);
}

$(document).ready(function(){
  $("body").delegate("a.cancel_message","click",function(e){
    var button = $("#new_message_button");
    button.popover("hide");
    //replacing the button with a clone of itself solves the problem where
    //once the popover is initialized, you can't change it's content. This way,
    //the button is replaced with a clone of itself, but without the already
    //initialized popover
    button.replaceWith(button.clone())
    e.preventDefault();
  });
  
  $("body").delegate("#filter_messages_form", "ajax:success", function(evt, data, status, xhr){
    $('.messages_list').html(xhr.responseText);
  });
  
  $("body").delegate(".reply_button", "ajax:success", function(evt, data, status, xhr){
    $(this).closest(".message_list_item").find(".reply_fields").html(xhr.responseText);
    styleFileInputs();
    $("#new_study_session .fake-file").css({position: "relative", top: "-34px"});
  });
  
  $("body").delegate(".cancel_reply", "click", function(){
    $(this).closest("#message_new").remove();
    return false;
  });
  
  $(".message_content .expand_message").click(function(){
    $(this).closest(".message_content").find(".full_message").toggleClass("hide");
    $(this).closest(".message_content").find(".message_preview").toggleClass("hide");
  });
});
