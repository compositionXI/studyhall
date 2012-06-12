# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('body.study_sessions-index #browser_video').mediaelementplayer
    defaultVideoWidth: 383
    defaultVideoHeight: 313
    loop: true
    features: ['playpause']
    enableAutosize: false
    success: (mediaElement) ->
      $("#browser_video").show()
      $('.mejs-layers, .mejs-controls').remove()
      $('.mejs-container').fadeIn 1000, ->
        mediaElement.play()
