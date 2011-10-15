# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  classmate_list_modal = $('#classmate_list_modal')
  classmate_list_modal.modal {backdrop: true}
  classmate_list_modal.modal("hide")
  
  $(".modal_button").bind "ajax:success", (evt, data, status, xhr) ->
    classmate_list_modal.find(".modal-body").html xhr.responseText
    classmate_list_modal.modal("show")