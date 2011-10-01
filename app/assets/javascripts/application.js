// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.masonry.min.js
//= require bootstrap-dropdowns.js
//= require bootstrap-twipsy.js
//= require bootstrap-popover.js
//= require bootstrap-modal.js
//= require_tree .

$(function(){
  $("a").twipsy({
        placement: "below"
      , offset: 10 
    });
    
    $('.large-bird').popover({
        content:          "data-content"
      , placement:        "below-left"
      , horizontalOffset: 25
    });
  
  $(".activity-list").jScrollPane();
  
  $(".nav").dropdown('.dropdown', true);
  
  $("#sortTableExample").tablesorter();
  
  
});