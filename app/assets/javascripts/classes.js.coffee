# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $class_activity = $('.course_activity')
    
  $class_scroll = $class_activity.find('.course_activity_list')
  $class_scroll.jScrollPane({hideFocus: true}) 
     
  class_scroll_api = $class_scroll.data('jsp')
  $class_scroll.on 'reinit', (e) ->
    class_scroll_api.reinitialise()
    
  $class_scroll.on 'click', '.comment_form_button, .cancel', (e) ->
      $class_scroll.trigger('reinit')
      e.preventDefault()
  
  $(".post_item a.collapse_button").live('click', (e) ->
    if $(this).hasClass('opened')
      $(this).removeClass('opened').addClass('closed')
      $(this).closest('.post_item').find('.comment_list').hide();      
      $(this).closest('.post_item').find('.comment_form').hide();      
    else
      $(this).addClass('opened').removeClass('closed')
      $(this).closest('.post_item').find('.comment_list').show();      
      $(this).closest('.post_item').find('.comment_form').show();      
  )
