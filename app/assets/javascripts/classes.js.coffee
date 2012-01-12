# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.course_activity')
    .on 'click', '.comment_form_button, .cancel', (e) ->
      e.preventDefault()
    .find('.course_activity_list').jScrollPane()