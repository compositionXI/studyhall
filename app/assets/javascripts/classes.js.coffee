# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	newStudyhallModal = $("#new_studyhall_modal")
	newStudyhallModal.dialog
  	modal: true
  	autoOpen: false

	$("#new_sutdyhall_btn").click (e) ->
		$.get "/study_sessions/new", (data) -> 
			newStudyhallModal.html data
			newStudyhallModal.dialog('open')

			newStudyhallModal.find(".close_modal").click (e) ->
				e.preventDefault()
				newStudyhallModal.dialog('close')