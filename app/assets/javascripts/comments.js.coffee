# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("body").delegate ".comment_form_button", "click", ->
    comment_id = $(this).attr("name")
    $("#"+comment_id).css "display", "block"
    if $('.course_activity_list ul').height() < 600
      $(".course_activity .jspContainer").height($('.course_activity_list ul').height())
    else
      $(".course_activity .jspContainer").height(600)
    pane_api = $('.course_activity_list').data('jsp')
    pane_api.reinitialise()
    pane_api.scrollToElement($(this).closest('.post_item').find('.comment_form'), true, false)
    
  $("body").delegate ".comment_form .cancel", "click", ->
    $(this).closest(".comment_form").css "display", "none"
