var selectOptionFrom = function(chznOption){
  optionIndex = parseInt(chznOption.attr("id").match(/\d+/)[0]);
  selecteOption = $("#select_action option")[optionIndex];
  return $(selecteOption);
}

var selectAll = function(checked){
  checked = typeof checked != 'undefined' ? checked : "checked";
  $(".message_list_item .checkbox input").attr("checked", checked);
}

var switchInboxView = function(){
  toggleActionBarButtons();
  $(".message_list_item .checkbox, .message_utilities").toggleClass("hide");
}

var toggleActionBarButtons = function(){
  $(".default_message_buttons, .edit_message_buttons").toggleClass("hide");
}

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
  message_list_item.find(".expanded_message").toggleClass("hide");
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
    if(inboxCount - 1 == 0) {
      $(".inbox_message_count").html("");
      $(".inbox_message_count").addClass('hide');
    } else {
      $(".inbox_message_count").html(inboxCount - 1);
      $(".inbox_message_count").removeClass('hide');
    }
  } else {
    $(".inbox_message_count").html(inboxCount + 1);
    $(".inbox_message_count").removeClass('hide');
  }
}

var resetMessageCount = function(){
  unreadCount = $(".message_list_item .unread").length;
  resetValue = (unreadCount == 0) ? "" : unreadCount;
  $(".inbox_message_count").html(resetValue);
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
      message_list_item.replaceWith(response);
      if(message_list_item.find('.message_action.unarchive').length == 0) {
        updateMessageCount(read);
      }
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
  
  
  $("body").delegate(".message_utilities .archive, .message_utilities .unarchive", "click", function(){
    var message_list_item = $(this).closest(".message_list_item");
    var url = $(this).attr("data-url");
    var data = $(this).hasClass("archive") ? {"message[deleted]": true} : {"message[deleted]": false};
    updateMessage(message_list_item, url, data);
    if(message_list_item.find('.message_action.mark_unread').length == 0) {
      $(this).hasClass("archive") ? updateMessageCount(true) : updateMessageCount(false);
    }
    return false;
  });
  
  $("body").delegate(".message_utilities .report_spam, .message_utilities .report_abuse", "click", function(){
    var message_list_item = $(this).closest(".message_list_item");
    var url = $(this).attr("data-url");
    var data = $(this).hasClass("report_spam") ? {"message[spam]": true} : {"message[abuse]": true};
    if( confirm("Are you sure?") ){
      updateMessage(message_list_item, url, data);
      updateMessageCount(true);
      return false;
    }
  });
  
  $("body").delegate(".message_utilities .mark_read, .message_utilities .mark_unread", "click", function(){
    var message_list_item = $(this).closest(".message_list_item")
    var url = $(this).attr("data-url");
    $(this).bind('click', function() { return false; });//prevent multiple clicking
    ajaxUpdateMessageRead(url, message_list_item, $(this).hasClass("mark_read"));
    return false;
  });
  
  $("body").delegate(".chzn-results li.update_messages", "click", function(){
    updateMultiForm = $("#save_multiple_messages_form");
    var checkedMessages = $(".checkbox :checked");
    var updateAttribute = selectOptionFrom($(this)).attr("data-update-attribute");
    var updateAttributeValue = selectOptionFrom($(this)).attr("data-attribute-value");
    checkedMessages.each(function(){
      var input = $(this).closest(".edit_message_fields").find("."+updateAttribute).attr("value", updateAttributeValue);
      updateMultiForm.prepend($(this));
      updateMultiForm.prepend(input);
    });
    updateMultiForm.submit();
    updateMultiForm.find(".update_multi").remove();
  });
  
  $("body").delegate("#save_multiple_messages_form", "ajax:success", function(evt, data, status, xhr){
    $('.messages_list').html(xhr.responseText);
    resetMessageCount();
    toggleActionBarButtons();
  });
  
  $("body").delegate(".attachment_link", "click", function(e){
    e.preventDefault();
    $(this).closest(".reply_fields").find("input[type='file']").trigger("click");
  });
  
  $("body").delegate("#message_attachment", "change", function(){
    var file = $(this).attr("value");
    $(".file_upload_name").html(file);
  });
  
  $(".default_message_buttons .edit, .edit_message_buttons .cancel").click(function(){
    switchInboxView();
  });
  
  $(".edit_message_buttons").find(".select_all, .select_none").click(function(){
    $(this).hasClass("select_all") ? selectAll() : selectAll(false);
    $(".edit_message_buttons").find(".select_none, .select_all").toggleClass("hide");
  });
});
