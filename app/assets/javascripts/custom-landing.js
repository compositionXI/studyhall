// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.jscrollpane
//= require jquery.validate.min
//= require bootstrap-twipsy.js
//= require mediaelement_rails
//= require modernizr
//= require landing

$(function(){
  //Mouse cursor alterations during AJAX operations
  var ajaxCursor;
  ajaxCursor = function() {
    return $("html").bind("ajaxStart", function() {
      return $(this).addClass('busy');
    }).bind("ajaxStop", function() {
      return $(this).removeClass('busy');
    });
  };
  
  ajaxCursor();
  
});
