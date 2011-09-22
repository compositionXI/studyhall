$(document).ready ->
	$('.rte_area').rte("/assets/rte.css")
	
	saveNoteModal = $("#save_note_modal")
	
	saveNoteModal.dialog {
		modal: true
		autoOpen: false
	}
	
	note_content = $("#note_content_hidden_field").attr("value")
	$("#rte_area_note_content").contents().find("body").html(note_content)
	
	
	$("#save_note_btn").click (e) ->
		saveNoteModal.dialog('open')
	
	$("#save_note_submit_button").click (e) ->
		note_content = $("#rte_area_note_content").contents().find("body").html()
		$("#note_content_hidden_field").attr("value", note_content)