$ ->
  $(".follow_button, .unfollow_button").live "ajax:success", (e, data)->
    if data
      $(".follow_button, .unfollow_button").toggleClass "hidden"
    else
      $("#flash .notice").html "Your request could not be processed."
