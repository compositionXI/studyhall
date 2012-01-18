# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

default_profile_image_path = "/assets/generic_avatar_thumb.png"

class completion_percentage
  
  setup: ->
    self = this 
    @wizard = $('.profile_wizard')
    if $(".avatar", @wizard).attr('data-default-url') == 'true'
      $('#user_avatar', @wizard ).attr('data-countable', 'true') 
    
    @input = $('input[data-countable="true"], select[data-countable="true"]', @wizard)
    @totalFields = 11 # hard code the total fields which used to check completion
    @meter = $("#profile_completion_meter")
    @others_count = parseInt($("#others_profile_complete_count").val())
    if $('div[data-default-url]').length == 0
      @default_avatar = false
    else
      @default_avatar = true
    
    self.update(@input.first())
  
  update: (element)->
    self = this
    @count = 0
    @input.each (i, field) ->
      $field = $(field)
      if $field.val() != '' && $field.val() != null
        self.count++
    
    unless @default_avatar
      @count = @count + 1
    
    $el = $(element) 
    top = $el.position().top
    if top == 0
      top = $el.parent().position().top
    percentage = parseInt( (@count + @others_count)/@totalFields * 100 )
    
    @meter
      .find('p').text( percentage + "% Complete" )
      .end()
      .stop()
    if percentage < 100
      @meter
        .css
          "display" : "block"
        .animate
          "top": top
          "opacity" : 1
    else
      @meter.fadeOut()
$ ->
  #$("#profile_tabs").tabs()
  # $(".chzn-select").css({"display": "none"})
  $('#user_extracurriculars_chzn.chzn-container .chzn-choices .search-field').change ->
    $('.chzn-select.appendable').append('<option>'+this.value+'</option>')
    $('.chzn-select.appendable').trigger('liszt:updated')
  
  #$('.sorority, .fraternity').css("display", "none")
  #switch_greek_select_box()
  #$('.gender select').change ->
  #  console.log "lskdj"
  #  switch_greek_select_box()
  
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
  
  #$("#edit_gpa_form").bind "ajax:success", (event, response) ->
  #  $("#profile_edit_gpa").animate {opacity: 0,}, 200, ->
  #    $("#profile_edit_gpa #gpa").html(response.gpa)
  #    $(this).animate {opacity: 1}, 200
  
  #$("#edit_bio_form").bind "ajax:success", (event, response) ->
  #  $("#profile_bio").animate {opacity: 0,}, 200, ->
  #    $("#profile_bio #bio").html(response.bio)
  #    $(this).animate {opacity: 1}, 200
  
  get_extracurriculars = () ->
    $.getJSON "extracurriculars", (json) ->
      json.terms
  
  split = (val) ->
    return val.split( /,\s*/ )
  extractLast = (term) ->
    return split(term).pop()
  
  #Autocomplete for extracurriculars
  $("body").delegate "#extracurriculars_list", "keydown", (event) ->
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
  
  $("body").delegate ".buddy_list_item .unfollow_button", "ajax:success", (event, response)->
    unless 0 == $('.action_bar .editable').length
      buddy_list_item = $(this).closest(".buddy_list_item")
      user_href = buddy_list_item.find("a").attr("href")
      preview_buddy_image = $("section.buddies a[href='"+user_href+"']").closest("li")
      preview_buddy_image.fadeOut 500
      total_buddies = $("#view_all_buddies .total_buddies")
      new_buddies_total = parseInt(total_buddies.html()) - 1
      total_buddies.html(new_buddies_total)
      $("section.buddies .total_buddies").html(new_buddies_total)
      buddy_list_item.fadeOut 500, ->
        buddy_list_item.html "<div class=\"alert-message warning\">You are no longer following this user.</div>"
        buddy_list_item.fadeIn 0
        setTimeout -> 
          buddy_list_item.fadeOut(3000)
        , 3000

  if $('.profile_wizard').length != 0
    completion = new completion_percentage
    completion.setup()   
    completion.wizard.delegate '.chzn-container', 'click focus mouseup', (e) ->
      completion.update(this)
    completion.input.bind 'click focus keyup change', (e) ->
      completion.update(this)
