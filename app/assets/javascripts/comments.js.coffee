# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("body").delegate ".comment_form_button", "click", ->
    comment_id = $(this).attr("name")
    $("#"+comment_id).css "display", "block"
  $("body").delegate ".comment_form .cancel", "click", ->
    $(this).closest(".comment_form").css "display", "none"