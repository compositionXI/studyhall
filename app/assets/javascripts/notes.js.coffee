$(document).ready ->
  $('.rte_area').rte("/assets/rte.css")
  
  saveNoteModal = $("#save_note_modal")
  
  saveNoteModal.dialog {
    modal: true
    autoOpen: false
    open: (event, ui) -> $(".ui-dialog-titlebar-close", ui.dialog).hide()
  }
  
  note_content = $("#note_content_hidden_field").attr("value")
  $("#rte_area_note_content").contents().find("body").html(note_content)
  
  $("#save_note_btn").click (e) ->
    saveNoteModal.dialog('open')
    saveNoteModal.find(".close_modal").click (e) ->
      saveNoteModal.dialog('close')
  
  $("#save_note_submit_button").click (e) ->
    note_content = $("#rte_area_note_content").contents().find("body").html()
    $("#note_content_hidden_field").attr("value", note_content)
  
  $("body").delegate "#edit_note_form", "ajax:success", (evt, data, status, xhr) ->
    link_id = $(".cancel_popover").attr("data-link-id")
    $("##{link_id}").popover("hide")
    $("##{link_id}").closest(".note_list_item").replaceWith xhr.responseText
