# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$("#profile_tabs").tabs()

	edit_personal_info_modal = $(".edit_personal_info")
	edit_gpa_modal = $(".edit_gpa")
	change_profile_photo_modal = $(".edit_profile_photo")
	
	$(".profile_edit_modal").dialog
		modal: true
		autoOpen: false
		open: (event, ui) -> $(".ui-dialog-titlebar-close", ui.dialog).hide()
	
	$("#profile_personal_info").click (e) ->
		edit_personal_info_modal.dialog("open")	
	
	$("#profile_edit_gpa").click (e) ->
		edit_gpa_modal.dialog("open")
	
	$("#change_profile_photo").click (e) ->
		change_profile_photo_modal.dialog("open")
	
	$(".close_modal").click (e) ->
		$(this).parents(".profile_edit_modal").dialog("close")
	
	edit_personal_info_modal = $(".edit_personal_info")
	edit_gpa_modal = $(".edit_gpa")
	edit_profile_photo_modal = $(".edit_profile_photo")
	editModals = [edit_personal_info_modal[0], edit_gpa_modal[0], edit_profile_photo_modal[0]]


	$(editModals).find(".save").click ->
		modal = $(this).parents(".profile_edit_modal")
		modal.dialog("close")

	photoSuccess = (result) ->
		edit_profile_photo_modal.dialog("close")
		$("#profile_sidebar #profile_photo").attr("src", result.avatar_url)

	$("#edit_profile_photo_form").bind("ajax:success", photoSuccess)

	$("#edit_personal_info_form").bind "ajax:success", (event, response) ->
		$("#profile_personal_info").animate { opacity: 0 }, 200, ->
			$("#profile_detailed_info #school").html(response.greek_house)
			$("#profile_detailed_info #school").html(response.school)
			$("#profile_detailed_info #major").html(response.major)
			$(this).animate {opacity: 1}, 200

	$("#edit_gpa_form").bind "ajax:success", (event, response) ->
		$("#profile_edit_gpa").animate {opacity: 0,}, 200, ->
			$("#profile_edit_gpa #gpa").html(response.gpa)
			$(this).animate {opacity: 1}, 200
