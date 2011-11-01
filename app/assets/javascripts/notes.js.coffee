$ ->
  $('.rte_area').cleditor({width: 936, height: 700, bodyStyle: "padding:50px 130px", useCSS: true, docCSSFile: "/stylesheets/cleditor.css"}).focus()
  $('.cleditorToolbar').hide();
  
  $("body").delegate "#edit_note_form", "ajax:success", (evt, data, status, xhr) ->
    link_id = $(".cancel_popover").attr("data-link-id")
    $("##{link_id}").popover("hide")
    $("##{link_id}").closest(".note_list_item").replaceWith xhr.responseText

  $("#menubar").delegate ".formatting_toggle", "click", (e) ->
    $(".formatting_toggle").toggle()
    $(".cleditorToolbar").toggle()
    e.preventDefault()
