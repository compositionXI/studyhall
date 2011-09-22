$ ->
  $("#new_notebook_modal").dialog
    modal: true
    autoOpen: false

  $("#new_notebook_btn").click (e) ->
    $.get "notebooks/new", (data) ->
      newNotebookModal = $("#new_notebook_modal")
      newNotebookModal.html data
      newNotebookModal.dialog('open')

      newNotebookModal.find(".close_modal").click (e) ->
        newNotebookModal.dialog('close')

  notebookListContainer = $('.notebook_list_container')
  $("#items_layout_switcher").delegate 'a[data-layout]', 'click', ->
    notebookListContainer.attr 'class', 'notebook_list_container ' + $(this).data('layout')

    false
