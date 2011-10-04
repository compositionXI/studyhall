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
  
  $("#styleguide-form select").chosen()  
                        
  // Code for styling file upload inputs. Needs to be extracted and pluginified
   
  $(".input-file").each(function(){    
    var $this = $(this)
    ,   origWidth = $this.outerWidth()
    ,   $fakeyInput = $("<div id='thing' class='fake-file'><input type='text'><span class='btn'>Browse</span>");

    $this.parent('.input').css({ position: "relative" });
    
    $this.after( $fakeyInput ).css({    
      cursor : "pointer"
      , height : 37
      , padding : "0 5px 0 0"
      , opacity : 0 
      , position : "relative"
      , "z-index" : 5
    });  
    
    var buttonWidth = $(".fake-file .btn").outerWidth()
    ,   finalWidth = origWidth - buttonWidth - 5;
    
    $(".fake-file input").css({width : finalWidth });
    
    $this.change( function () {    
      $this.siblings('.fake-file').find('input').val( this.value )      
    });                           
  });
  
   
  
});

$(document).ready(function(){
  $("body").delegate("a.cancel_notebook","click",function(e){
    $("#new_notebook_button").popover("hide");
    e.preventDefault();
  });
});
