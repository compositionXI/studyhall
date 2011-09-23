class NotebookContainer
  HASH_PREFIX = '#layout'

  className = 'notebook_list_container'

  constructor: (theClassName) ->
    className ||= theClassName
    @container = $('.' + className)

  setup: ->
    @container.delegate 'a.expand_collapse_icon', 'click', ->
      notebookListItem = $(this).closest('.notebook_list_item')
      if notebookListItem.hasClass 'collapsed'
        notebookListItem.removeClass 'collapsed'
        $(this).text('x')
      else
        notebookListItem.addClass 'collapsed'
        $(this).text('+')

      false

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