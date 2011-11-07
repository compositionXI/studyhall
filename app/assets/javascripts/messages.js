var updateMessage = function(message_list_item, url, data, requestType){
  requestType = typeof requestType != 'undefined' ? requestType : "PUT";
  var messageType = message_list_item.attr("data-message-type");
  data.message_type = messageType;
  $.ajax({
    url: url,
    data: data,
    type: requestType
  });
}

var hide_message = function(selector){
  $("#"+selector).delay(400).slideUp(1000);
}

var hideShowMessage = function(message_list_item_id){
  var message_list_item = $("#"+message_list_item_id);
  message_list_item.find(".collapsed_message").toggleClass("highlighted");
  message_list_item.find(".expanded_message, .message_preview").toggleClass("hide");
  message_list_item.find("#message_new textarea").first().focus();
}

var isShowingFullMessage = function(message_list_item_id){
  var message_list_item = $("#"+message_list_item_id);
  !message_list_item.find(".full_message, .message_preview").hasClass("hide");
}

var updateMessageCount = function(read){
  var inboxCount = parseInt($(".inbox_message_count").html());
  var inboxCount = (inboxCount) ? inboxCount : 0;
  if (read) {
    (inboxCount - 1) == 0 ? $(".inbox_message_count").html("") : $(".inbox_message_count").html(inboxCount - 1);
  }
  else {
    $(".inbox_message_count").html(inboxCount + 1);
  }
}

var ajaxUpdateMessageRead = function(url, message_list_item, read, async){
  async = typeof async != 'undefined' ? async : true;
  var messageType = message_list_item.attr("data-message-type");
  $.ajax({
    url: url,
    data: {message : {opened : read}, message_type: messageType},
    type: "PUT",
    dataType: "html",
    async: async,
    success: function(response){
      message_list_item.replaceWith(response)
      updateMessageCount(read);
    }
  });
}

var ajaxGetReplyForm = function(url, message_list_item_id, async){
  async = typeof async != 'undefined' ? async : true;
  var message_list_item = $("#"+message_list_item_id);
  data = {parent_id: message_list_item_id.match(/\d*$/)[0]};
  $.ajax({
    url: url,
    data: data,
    async: async,
    success: function(response){
    message_list_item.find(".reply_fields").html(response);
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
  
  $("body").delegate(".cancel_reply", "click", function(){
    $(this).closest("#message_new").remove();
    return false;
  });
  
  $("body").delegate( ".message_list_item .inner_link", "click", function(event){
    event.stopPropagation();
    return false;
  });
  
  $("body").delegate(".collapsed_message", "click", function(){
    var message_list_item = $(this).closest(".message_list_item");
    var message_list_item_id = message_list_item.attr("id");
    if (message_list_item.find(".collapsed_message").hasClass("unread")){
      var updateUrl = message_list_item.find(".mark_read").attr("data-url");
      ajaxUpdateMessageRead(updateUrl, message_list_item, true, false);
    }
    if (message_list_item.find(".expanded_message").hasClass("hide")){
      var replyUrl = $(this).attr("data-message-reply-url");
      ajaxGetReplyForm(replyUrl, message_list_item_id, false);
    }
    else {
      message_list_item.find(".cancel_reply").trigger("click");
    }
    hideShowMessage(message_list_item_id);
  });
  
  $("body").delegate(".message_actions .archive, .message_actions .unarchive", "click", function(){
    var message_list_item = $(this).closest(".message_list_item");
    var url = $(this).attr("data-url");
    var data = $(this).hasClass("archive") ? {"message[deleted]": true} : {"message[deleted]": false};
    updateMessage(message_list_item, url, data);
  });
  
  $("body").delegate(".message_actions .report_spam, .message_actions .report_abuse", "click", function(){
    var message_list_item = $(this).closest(".message_list_item");
    var url = $(this).attr("data-url");
    var data = $(this).hasClass("report_spam") ? {"message[spam]": true} : {"message[abuse]": true};
    if( confirm("Are you sure?") ){
      updateMessage(message_list_item, url, data);
    }
  });
  
  $("body").delegate(".message_actions .mark_read, .message_actions .mark_unread", "click", function(){
    var message_list_item = $(this).closest(".message_list_item")
    var url = $(this).attr("data-url");
    ajaxUpdateMessageRead(url, message_list_item, $(this).hasClass("mark_read"));
  });
  
  $(".edit_messages, .cancel_message_edit").click(function(){
    $(".edit_messages, .edit_message_buttons, .default_message_buttons, .edit_checkbox").toggleClass("hide");
  });
  
  $(".update_messages").click(function(){
    var updateAttribute = $(this).attr("data-update-attribute");
    var updateAttributeValue = $(this).attr("data-attribute-value");
    var updateMultipleForm = $("#save_multiple_messages_notes_form");
    var attribute = $("<input>").attr("type", "hidden").attr("name", "attribute").val(updateAttribute);
    var attribiteValue = $("<input>").attr("type", "hidden").attr("name", "attribute_value").val(updateAttributeValue);
    updateMultipleForm.append($(attribute));
    updateMultipleForm.append($(attribiteValue));
    updateMultipleForm.submit();
  });
  
  $("body").delegate(".attachment_link", "click", function(e){
    e.preventDefault();
    $(this).closest(".reply_fields").find(".input-file").trigger("click");
  });
  
  $("body").delegate("#message_attachment", "change", function(){
    var file = $(this).attr("value");
    $(".file_upload_name").html(file);
  });
});