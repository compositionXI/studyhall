selectAll = ->
  $(".note_item").addClass("selected")

selectNone = ->
  $(".note_item").removeClass("selected")

toggleActionButtons = ->
  if $(".note_item.selected").length > 0
    $(".action_button").removeClass("disabled")
  else
    $(".action_button").addClass("disabled")

initDragAndDrop = ->
  $(".draggable").draggable('destroy')
  $(".draggable").draggable
    start: ->
      $(".ui-draggable").css({opacity: .5})
      $(this).closest(".droppable").droppable('disable')
      if $(this).hasClass "child_note"
        drop_area = $("<li class='note_item drop_area'><p>Drop your note here to move it out of a Notebook...</p></li>")
        drop_area.droppable
          hoverClass: 'draggable_hovering'
          drop: (e, ui) ->
            moveNoteOutOfNotebook(ui.draggable)
        $(this).closest(".note_item").after(drop_area)
        $('.note_items').data('jsp').reinitialise({hideFocus: true})
    stop: ->
      $(".ui-draggable").css({opacity: 1})
      $(this).closest(".droppable").droppable('enable')
      $(".drop_area").slideUp().remove()
      $('.note_items').data('jsp').reinitialise({hideFocus: true})
    handle: '.drag_handle'
    containment: '.note_items'
    revert: 'invalid'
    zIndex: 1000
    helper: ->
      thing = $(this).clone().removeClass("ui-draggable").css({"list-style": "none", "border-bottom": "none"})
      thing.find(".name, .list_data").remove()
      thing
  $(".droppable").droppable('destroy')
  $(".droppable").droppable
    hoverClass: 'draggable_hovering'
    drop: (e, ui) ->
      moveNoteToNotebook(ui.draggable, $(this))

tearDownDragAndDrop = ->
  $(".draggable").draggable('destroy')
  $(".droppable").droppable('destroy')

moveNoteOutOfNotebook = (note) ->
  noteId = note.data("id")
  $.ajax
    url: ['notes', noteId, 'move'].join '/'
    type: 'PUT'
    beforeSend: ->
      note.animate({opacity: .3,overflow: 'hidden'})
    success: (data) ->
      direction = "left"
      if note.hasClass("list")
        direction = "up"
      note.hide("slide", { direction: direction}, 1000)
      note_items = $(".note_items .jspPane li")
      note_items.first().before(data.html)
      $(".note_items .jspPane li").first().removeClass("grid").addClass("list edit")
      $('.note_items').jScrollPane().data('jsp').reinitialise({hideFocus: true})
      initDragAndDrop()

moveNoteToNotebook = (note, notebook) ->
  notebookId = notebook.data("id")
  noteId = note.data("id")
  $.ajax
    url: ['/notebooks', notebookId, 'notes', noteId, 'move'].join '/'
    type: 'PUT'
    beforeSend: ->
      note.animate({opacity: .3,overflow: 'hidden'})
    success: (data) ->
      direction = "left"
      if note.hasClass("list")
        direction = "up"
      note.hide("slide", { direction: direction}, 1000)
      notebook = $("#notebook_"+notebookId)
      notebook.find(".child_notes").append(data.html)
      notebook.find(".notebook_expander").show()
      if notebook.hasClass("list")
        notebook.find(".child_notes li").last().addClass("list")
      else
        notebook.find(".child_notes li").last().addClass("grid")
      $('.note_items').data('jsp').reinitialise({hideFocus: true})
      initDragAndDrop()

$(document).ready ->
  $(".layout_button").click (e) ->
    $(".note_item").removeClass("grid list").addClass($(this).data("layout"))
    if($(this).data("layout") == "list")
      $(".note_items").jScrollPane({hideFocus: true})
    else
      $(".child_notes").hide()
      $(".note_items").jScrollPane(false)
    e.preventDefault()

  $(".note_items").delegate ".notebook_expander","click", (e) ->
    $("#"+$(this).data("rel")).slideToggle()
    setTimeout("$('.note_items').data('jsp').reinitialise({hideFocus: true})",1100)
    e.stopPropagation()
    e.preventDefault()

  if $("body").hasClass("notes-index")
    $(".note_items").delegate ".note_item.show","click", (e) ->
      window.location = $(this).data("href")
      e.stopPropagation()
      e.preventDefault()

    $(".note_items").delegate ".note_item.edit","click", (e) ->
      $(this).toggleClass("selected")
      toggleActionButtons()
      e.preventDefault()
      e.stopPropagation()

    $(".note_items").delegate ".note_item.notebook.edit","dblclick", (e) ->
      e.preventDefault()
      e.stopPropagation()
      modal_id = "#notebook_" + $(this).data("id") + "_modal"
      $(modal_id).modal
        keyboard: true
        show: true
        backdrop: true
      $(modal_id).find(".cancel_popover").click (e) ->
        $(modal_id).modal('hide')
        e.preventDefault()
    ###
    This prevents the text from being selected when a notebook is double-clicked
    ###
    $(".note_items").delegate ".note_item.notebook.edit", "mousedown", ->
      return false

    $(".action_bar").delegate "#edit_notes","click", (e) ->
      $(".note_item").removeClass("show").addClass("edit")
      $(".show_button").hide()
      $(".edit_button").show().css({display: "inline-block"})
      $(".action_bar .edit").show()
      $(".action_bar .show").hide()
      initDragAndDrop()
      e.preventDefault()

    $(".action_bar").delegate "#show_notes","click", (e) ->
      $(".note_item").removeClass("edit").removeClass("selected").addClass("show")
      $(".show_button").show().css({display: "inline-block"})
      $(".edit_button").hide()
      $(".action_bar .edit").hide()
      $(".action_bar .show").show()
      tearDownDragAndDrop()
      e.preventDefault()

    $(".action_bar").delegate "#select_all","click", (e) ->
      selectAll()
      $(".action_bar .select").toggle()
      toggleActionButtons()
      e.preventDefault()

    $(".action_bar").delegate "#select_none","click", (e) ->
      selectNone()
      $(".action_bar .select").toggle()
      toggleActionButtons()
      e.preventDefault()

  if $("body").hasClass("notes-edit") || $("body").hasClass("notes-new")
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
