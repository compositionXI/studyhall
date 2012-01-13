$ ->
  $("body.searches-show .request_note_access_button").live "ajax:success", (e, data) ->
    $(this).remove()
  
