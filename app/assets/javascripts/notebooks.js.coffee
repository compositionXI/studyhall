$ ->
	newNotebookModal = $("#new_notebook_modal")
	
	newNotebookModal.dialog
  	modal: true
  	autoOpen: false

  $("#new_notebook_btn").click (e) ->
    $.get "notebooks/new", (data) ->
      newNotebookModal.html data
      newNotebookModal.dialog('open')

  		newNotebookModal.find(".close_modal").click (e) ->
		  	newNotebookModal.dialog('close')

  notebookListContainer = $('.notebook_list_container')

  # recover layout from hash
  [prefix, layout] = location.hash.split '/', 2

  if prefix is '#layout'
    notebookListContainer.attr 'class', 'notebook_list_container ' + layout

  $("#items_layout_switcher").delegate 'a[data-layout]', 'click', ->
    notebookListContainer.attr 'class', 'notebook_list_container ' + $(this).data('layout')
    window.location.hash = '#layout/' + $(this).data('layout')

    false

  notebookListContainer.delegate 'a.expand_collapse_icon', 'click', ->
    notebookListItem = $(this).closest('.notebook_list_item')
    if notebookListItem.hasClass 'collapsed'
      notebookListItem.removeClass 'collapsed'
      $(this).text('x')
    else
      notebookListItem.addClass 'collapsed'
      $(this).text('+')

    false