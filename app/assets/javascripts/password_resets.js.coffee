# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#reset_password form").submit (e)->
    form = $(this)
    newPw = form.find("#user_password").val()
    newPwConfirmation = form.find("#password_confirmation").val()
    if newPw != newPwConfirmation
      form.find(".validation_error").show()
      e.stopPropagation()
      return false
      