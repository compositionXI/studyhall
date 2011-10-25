# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("body").delegate "#post_form_button, #filter_posts_form, .comment_form_button", "ajax:success", (evt, data, status, xhr) ->
    $("#filter_posts_button").popover("hide")
    $("#class_share_button").popover("hide")
    $('.course_activity_list').html xhr.responseText