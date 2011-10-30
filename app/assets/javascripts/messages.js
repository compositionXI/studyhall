var hide_message = function(selector){
  $("#"+selector).delay(400).slideUp(1000);
}

var hideShowMessage = function(message_list_item_id){
  var message_list_item = $("#"+message_list_item_id);
  message_list_item.find(".collapsed_message").toggleClass("highlighted");
  message_list_item.find(".message_actions").toggleClass("hide");
  message_list_item.find(".full_message, .message_preview").toggleClass("hide");
}

var ajaxUpdateMessageRead = function(url, message_list_item, read, async){
  async = typeof async != 'undefined' ? async : true;
  $.ajax({
    url: url,
    data: {message : {opened : read}},
    type: "PUT",
    dataType: "html",
    async: async,
    success: function(response){
      message_list_item.replaceWith(response)
    }
  });
}

var ajaxGetReplyForm = function(url, message_list_item_id, async){
  async = typeof async != 'undefined' ? async : true;
  var message_list_item = $("#"+message_list_item_id);
  $.ajax({
    url: url,
    async: async,
    success: function(response){
    message_list_item.find(".reply_fields").html(response);
    styleFileInputs();
    $("#new_study_session .fake-file").css({position: "relative", top: "-34px"});
  }});
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
  
  //$("body").delegate(".reply_button", "ajax:success", function(evt, data, status, xhr){
  //  $(this).closest(".message_list_item").find(".reply_fields").html(xhr.responseText);
  //  styleFileInputs();
  //  $("#new_study_session .fake-file").css({position: "relative", top: "-34px"});
  //});
  
  $("body").delegate(".cancel_reply", "click", function(){
    $(this).closest("#message_new").remove();
    return false;
  });
  
  $("body").delegate( ".message_list_item .inner_link", "click", function(event){
    event.stopPropagation();
  });
  
  $("body").delegate(".collapsed_message", "click", function(){
    var message_list_item = $(this).closest(".message_list_item");
    var message_list_item_id = message_list_item.attr("id");
    if (message_list_item.find(".collapsed_message").hasClass("unread")){
      var updateUrl = message_list_item.find("option.mark_read").attr("value");
      ajaxUpdateMessageRead(updateUrl, message_list_item, true, false);
    }
    if (message_list_item.find(".full_message").hasClass("hide")){
      var replyUrl = $(this).attr("data-message-reply-url");
      ajaxGetReplyForm(replyUrl, message_list_item_id, false);
    }
    else {
      message_list_item.find(".cancel_reply").trigger("click");
    }
    hideShowMessage(message_list_item_id);
  });
  
  $("body").delegate(".message_actions select option.archive", "click", function(){
    var url = $(this).attr("value");
    $.ajax({
      url: url,
      type: "DELETE"
    });
  });
  
  $("body").delegate(".message_actions select option.unarchive", "click", function(){
    var url = $(this).attr("value");
    $.ajax({
      url: url,
      type: "PUT"
    });
  });
  
  $("body").delegate(".message_actions select option.mark_read", "click", function(){
    var message = $(this).closest(".message_list_item")
    var url = $(this).attr("value");
    ajaxUpdateMessageRead(url, message, true);
  });
  
  $("body").delegate(".message_actions select option.mark_unread", "click", function(){
    var message_list_item = $(this).closest(".message_list_item")
    var url = $(this).attr("value");
    ajaxUpdateMessageRead(url, message_list_item, false);
  });
});