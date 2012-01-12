# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".masonry_container").masonry
    itemSelector: "masonry_item",
    columnWidth : 150
  
  $("body").delegate "#add_course_form", "ajax:success", (evt, data, status, xhr) ->
    $(".popover").remove()
    $('.course_list').html xhr.responseText
    $('.course_list').append("<li class='add'><a id='add_course_button' href='#' data-original-title=''><span>Add a course</span></a></li>")
  
  $(".alert .close").click ->
    $(".alert").css "display", "none"
    
  $('#home_tabs').tabs()
  $('#home_tabs').bind(
    'change',
     (e)->
      $($(e.target).attr('href')).jScrollPane({hideFocus: true})
  )
  
