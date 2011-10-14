# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

default_profile_image_path = "/assets/generic_avatar_thumb.png"

switch_greek_select_box = ()->
  if ($('.gender select').attr('value') == "Male")
    $('.fraternity').css("display", "block")
    $('.sorority').css("display", "none")
  else
    $('.sorority').css("display", "block")
    $('.fraternity').css("display", "none")

completion_percentage = () ->
  count = 0
  total_fields = 0
  $(".profile_wizard input, .profile_wizard textarea, .profile_wizard select").each ->
    if $(this).attr("data-counted") == "true"
      count += 1 if $(this).val() != "" && $(this).val() != null
      total_fields += 1
  if $(".profile_wizard #user_avatar").val() == "" && $(".profile_wizard .avatar").attr("data-default-url") != "true"
    count += 1
  Math.round( count/total_fields * 100 )

$ ->
  $("#profile_tabs").tabs()
  # $(".chzn-select").css({"display": "none"})
  $('#user_extracurriculars_chzn.chzn-container .chzn-choices .search-field').change ->
  $('.chzn-select.appendable').append('<option>'+this.value+'</option>')
  $('.chzn-select.appendable').trigger('liszt:updated')
  
  $('.sorority, .fraternity').css("display", "none")
  switch_greek_select_box()
  $('.gender select').change ->
    switch_greek_select_box()
  
  edit_personal_info_modal = $(".edit_personal_info")
  edit_bio_modal = $(".edit_bio")
  edit_gpa_modal = $(".edit_gpa")
  edit_profile_photo_modal = $(".edit_profile_photo")
  
  $(".profile_edit_modal").dialog
    modal: true
    autoOpen: false
    open: (event, ui) -> $(".ui-dialog-titlebar-close", ui.dialog).hide()
  
  $("#profile_detailed_info").click (e) ->
    edit_personal_info_modal.dialog("open")
  
  $("#profile_bio").click (e) ->
    edit_bio_modal.dialog("open")
  
  $("#profile_edit_gpa").click (e) ->
    edit_gpa_modal.dialog("open")
  
  $("#change_profile_photo").click (e) ->
    edit_profile_photo_modal.dialog("open")
  
  $(".close_modal").click (e) ->
    $(this).parents(".profile_edit_modal").dialog("close")
    
  editModals = [edit_personal_info_modal[0], edit_gpa_modal[0], edit_profile_photo_modal[0], edit_bio_modal[0]]
  
  $(editModals).find(".save").click ->
    modal = $(this).parents(".profile_edit_modal")
    modal.dialog("close")
  
  photoSuccess = (result) ->
    edit_profile_photo_modal.dialog("close")
    $("#profile_sidebar #profile_photo").attr("src", result.avatar_url)
  
  $("#edit_profile_photo_form").bind("ajax:success", photoSuccess)
  
  $("#edit_personal_info_form").bind "ajax:success", (event, response) ->
    $("#profile_personal_info").animate { opacity: 0 }, 200, ->
      $("#profile_detailed_info #greek_house").html(response.greek_house)
      $("#profile_detailed_info #school").html(response.school)
      $("#profile_detailed_info #major").html(response.major)
      $(this).animate {opacity: 1}, 200
  
  $("#edit_gpa_form").bind "ajax:success", (event, response) ->
    $("#profile_edit_gpa").animate {opacity: 0,}, 200, ->
      $("#profile_edit_gpa #gpa").html(response.gpa)
      $(this).animate {opacity: 1}, 200
  
  $("#edit_bio_form").bind "ajax:success", (event, response) ->
    $("#profile_bio").animate {opacity: 0,}, 200, ->
      $("#profile_bio #bio").html(response.bio)
      $(this).animate {opacity: 1}, 200
  
  get_extracurriculars = () ->
    $.getJSON "extracurriculars", (json) ->
      json.terms
  
  split = (val) ->
    return val.split( /,\s*/ )
  extractLast = (term) ->
    return split(term).pop()
  
  #Autocomplete for extracurriculars
  $( "#extracurriculars_list" ).bind "keydown", (event) ->
    if ( (event.keyCode == $.ui.keyCode.TAB) && $( this ).data( "autocomplete" ).menu.active )
      event.preventDefault()
  .autocomplete {
    source: ( request, response ) ->
      $.getJSON "extracurriculars", {term: extractLast(request.term)}, response
    
    ,focus: () -> 
      return false
    
    ,select: (event, ui) ->
      terms = split( this.value )
      terms.pop()
      terms.push( ui.item.value )
      terms.push( "" )
      this.value = terms.join( ", " )
      return false
  }
  
  getSelectedValue = (options) ->
    value = ""
    options.each ->
      if this.selected
        value = this.value
    value
  
  $("#user_school_id").chosen().change ->
    school_id = getSelectedValue $(this).find("option")
    $.get "/classes/0/offerings_for_school/#{school_id}", (response) ->
      $("#user_enrollments option").remove()
      newOptions = ""
      $(response.offerings).each (index) ->
        newOptions += "<option value='#{response.offering_ids[index]}'>#{this}</option>"
      $("#user_enrollments").html(newOptions).trigger("liszt:updated")
  
  $("#do_this_later").click (e) ->
    $('<input />').attr('type', 'hidden').attr('name', "do_this_later").attr('value', "true").appendTo('form')
    true
  
  $(".profile_wizard input, .profile_wizard textarea, .profile_wizard select").focus ->
    new_top = $(this).closest(".input").position()
    new_top = if new_top then new_top.top else ""
    $("#profile_completion_meter").html completion_percentage() + "% Complete"
    $("#profile_completion_meter").animate {"top": new_top}