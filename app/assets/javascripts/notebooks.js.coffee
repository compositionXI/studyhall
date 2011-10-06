class NotebookContainer
  HASH_PREFIX = '#layout'

  className = 'notebook_list_container'

  constructor: (theClassName) ->
    className ||= theClassName
    @container = $('.' + className)

  setup: ->
    @setupExpandCollapseIcon()
    @setupDragNDrop @container
    @setupSelectable()

  setupExpandCollapseIcon: ->
    @container.delegate 'a.expand_collapse_icon', 'click', ->
      notebookListItem = $(this).closest('.notebook_list_item')
      if notebookListItem.hasClass 'collapsed'
        notebookListItem.removeClass 'collapsed'
        $(this).text('x')
      else
        notebookListItem.addClass 'collapsed'
        $(this).text('+')

      false

  setupDragNDrop: (scope) ->
    notebookList = $('.notebook_list', @container)
    notebookContainer = this

    $('.note_list_item.edit_mode', scope).draggable
      start: (e, ui) ->
        $(this).addClass 'dragging_placeholder'
      stop: (e, ui) ->
        $(this).removeClass 'dragging_placeholder'
      helper: ->
        theHelper = $(this).clone().appendTo(notebookList)
        theHelper.width($(this).width())
      handle: '.drag_handle'
      scope: 'notes'
      revert: 'invalid'
      containment: 'document'
      scroll: false
      zIndex: 2700
    $('.notebook', scope).droppable
      scope: 'notes'
      hoverClass: 'draggable_hovering'
      drop: (e, ui) ->
        notebookContainer.moveNoteToNotebook $('.note', ui.draggable), $(this)

  setupSelectable: ->
    @container.delegate '.preview', 'click', (event) ->
      container = $(this).closest('.note, .notebook')
      checkbox = $('.checkbox input', container)
      unless $(event.target).is('a')
        if checkbox.prop('checked')
          checkbox.prop('checked', false)
          container.removeClass('checked')
        else
          checkbox.prop('checked', true)
          container.addClass('checked')

    @renderSelectable()

  renderSelectable: ->
    $('.note, .notebook').each ->
      checkbox = $('.checkbox input', $(this)).hide()
      if checkbox.prop('checked')
        $(this).addClass('checked')
      else
        $(this).removeClass('checked')

  moveNoteToNotebook: (note, notebook) ->
    notebookContainer = this
    noteId = note.attr('id').replace('note_', '')
    notebookId = notebook.attr('id').replace('notebook_', '')

    $.ajax
      url: ['/notebooks', notebookId, 'notes', noteId, 'move'].join '/'
      type: 'PUT'
      success: (data) ->
        newNotebookItem = $(data.html)
        notebook.closest('li').replaceWith(newNotebookItem)
        notebookContainer.setupDragNDrop newNotebookItem
        notebookContainer.renderSelectable()

        # remove from old notebook
        oldNotebook = note.closest('.notebook_list_item')
        oldNoteList = $('.note_list', oldNotebook)
        note.closest('li.note_list_item').remove()
        if $('li', oldNoteList).length == 0
          oldNoteList.remove()
          oldNotebook.addClass 'collapsed'
          $('.expand_collapse_icon', oldNotebook).remove()

      error: ->
        alert 'Cannot move note to the notebook'

  useLayout: (layout) ->
    @container.attr 'class', [className, layout].join(' ')
    window.location.hash = [HASH_PREFIX, layout].join('/')
    editAllHref = $(".action_bar a#edit_all").attr("href")
    if ~ editAllHref.indexOf("&layout=")
      newHref = editAllHref.replace(/&layout=\w*/, "&layout=#{layout}")
      $(".action_bar a#edit_all").attr("href", newHref)
    else
      $(".action_bar a#edit_all").attr("href", "#{editAllHref}&layout=#{layout}")

  recoverLayout: ->
    # recover layout from hash
    [prefix, layout] = location.hash.split '/', 2

    if prefix is HASH_PREFIX
      @useLayout layout


class NotebooksController
	setup: ->
		@setupNotebookContainer()

	setupNotebookContainer: ->
		notebookContainer = new NotebookContainer()
		notebookContainer.setup()
		notebookContainer.recoverLayout()

		$("#items_layout_switcher").delegate 'a[data-layout]', 'click', ->
			notebookContainer.useLayout $(this).data('layout')
			false

$ ->
	new NotebooksController().setup()
	
	$("#select_all").click ->
		$(".notebook, .note").addClass "checked"