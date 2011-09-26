class NotebookContainer
  HASH_PREFIX = '#layout'

  className = 'notebook_list_container'

  constructor: (theClassName) ->
    className ||= theClassName
    @container = $('.' + className)

  setup: ->
    @setupExpandCollapseIcon()
    @setupDragNDrop @container

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

    $('.note_list_item', scope).draggable
      appendTo: notebookList
      helper: 'clone'
      scope: 'notes'
      revert: 'invalid'
      containment: 'document'
      scroll: false
      zIndex: 2700
    $('.notebook', scope).droppable
      scope: 'notes'
      hoverClass: 'ui-state-highlight'
      drop: (e, ui) ->
        notebookContainer.moveNoteToNotebook $('.note', ui.draggable), $(this)

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

        # remove from old notebook
        oldNoteList = note.closest('ol.note_list')
        note.closest('li.note_list_item').remove()
        if $('li', oldNoteList).length == 0
          oldNoteList.remove()

      error: ->
        alert 'Cannot move note to the notebook'

  useLayout: (layout) ->
    @container.attr 'class', [className, layout].join(' ')
    window.location.hash = [HASH_PREFIX, layout].join('/')

  recoverLayout: ->
    # recover layout from hash
    [prefix, layout] = location.hash.split '/', 2

    if prefix is HASH_PREFIX
      @useLayout layout


class NotebooksController
  setup: ->
    @setupModalDialog()
    @setupNotebookContainer()


  setupModalDialog: ->
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

  setupNotebookContainer: ->
    notebookContainer = new NotebookContainer()
    notebookContainer.setup()
    notebookContainer.recoverLayout()

    $("#items_layout_switcher").delegate 'a[data-layout]', 'click', ->
      notebookContainer.useLayout $(this).data('layout')
      false

$ ->
  new NotebooksController().setup()