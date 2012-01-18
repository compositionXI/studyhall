# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("body").delegate "#post_form_button, #filter_posts_form, .comment_form", "ajax:success", (evt, data, status, xhr) ->
    $("#filter_posts_button").popover("hide")
    $("#class_share_button").popover("hide")
    pane_api = $('.course_activity_list').data('jsp')
    pane_api.getContentPane().html(xhr.responseText)
    if $('.course_activity_list ul').height() < 600
      $(".course_activity .jspContainer").height($('.course_activity_list ul').height())
    else
      $(".course_activity .jspContainer").height(600)
    pane_api.reinitialise()
