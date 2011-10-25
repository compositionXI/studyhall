$ ->
  $('.rte_area').rte("/assets/rte.css")
  
  note_content = $("#note_content_hidden_field").attr("value")
  $("#rte_area_note_content").contents().find("body").html(note_content)
  
  $("body").delegate "#edit_note_form", "ajax:success", (evt, data, status, xhr) ->
    link_id = $(".cancel_popover").attr("data-link-id")
    $("##{link_id}").popover("hide")
    $("##{link_id}").closest(".note_list_item").replaceWith xhr.responseText