// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery.expander.min.js
//= require jquery.remotipart
//= require jquery.cleditor
//= require bootstrap-dropdowns.js
//= require bootstrap-twipsy.js
//= require bootstrap-popover.js
//= require bootstrap-modal.js
//= require bootstrap-tabs.js
//= require mediaelement_rails
//= require_tree .

// Code for styling file upload inputs. Needs to be extracted and pluginified
var styleFileInputs = function(){
  $(".input-file").each(function(){    
    if(!$(this).hasClass("styled")){
      var $this = $(this)
      ,   origWidth = $this.outerWidth()
      ,   $fakeyInput = $("<div class='fake-file'><input type='text'><span class='btn'>Browse</span>");
    
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
      ,   finalWidth = origWidth - buttonWidth + 4;
      
      $(".fake-file input").css({width : finalWidth });
      $(".fake-file").click(function(e){
         $(this).siblings('input').trigger('click');
      });
      $this.change( function () {    
        $this.siblings('.fake-file').find('input').val( this.value )      
      });                           
      $(this).addClass("styled");
    }
  }); 
};

$(function(){
  initWindowResize = function(){
    var windowWidth = parseInt($(window).width());
    var initialLeft = parseInt($(".popover").css("left"));
    var bodyMinWidth = parseInt($("body").css("min-width"));
    var leftFromContainer = initialLeft - ((windowWidth - bodyMinWidth) / 2);
  
    $(window).bind("resize", function() {
      var newWidowWidth = parseInt($(window).width());
      var excessWidth = newWidowWidth - bodyMinWidth;
      if(excessWidth > 0) {
        var newLeft = leftFromContainer + (excessWidth / 2);
        $(".popover").css("left", newLeft);
      }
      else {
        $(".popover").css("left", leftFromContainer);
      }
    });
  }
  
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
  
  $("a").twipsy({
        placement: "below"
      , offset: 10 
    });
    
    $('.large-bird').popover({
        content:          "data-content"
      , placement:        "below-left"
      , horizontalOffset: 25
    });
  
  $(".activity-list").jScrollPane({hideFocus: true});
  $(".news-list").jScrollPane({hideFocus: true});
  
  
  // Code for Secondary Nav Dropdowns. Also needs to be pluginified.
  
  var d = 'a.menu, .dropdown-toggle', clearMenus = function() { 
    $(d).parent('li').removeClass('open')
  };
  $('html').bind("click", clearMenus)
  $("body").delegate(".secondary-nav .dropdown", "click", function(e){
     var li = $(this), isActive = li.hasClass('open')
     // clearMenus()
     li.toggleClass('open')
     return false
  }).find(".dropdown-menu a").click(function(e){
    e.stopPropagation();
  });
  
  $("#sortTableExample").tablesorter();
});

var quickSearch = function(){
  var input = $("#search_query");
  var form = input.closest("form");
  var url = form.prop("action")+".js?"+form.serialize()+"&models=user";
  $("#quick_search").remove();
  if(input.val().trim().length > 2){
    $.ajax({
      type: "GET",
      dataType: "script",
      url: url
    });
  }
}

$(document).ready(function(){
  //Disable following any anchor tag with the "disabled" class
  $("body").delegate("a,input[type='submit']","click", function(e){
    if($(this).hasClass("disabled")){
      e.stopPropagation();
      e.preventDefault();
    }
  });

  $("select.chzn-select").chosen();
  $("body").delegate("select.chzn-select", "change", function(){$(this).chosen();});
  
  $("body").delegate("a.cancel_popover","click",function(e){
    var linkId = $(this).attr("data-link-id"); //needed for pages that have multiple popovers.
    var button = linkId ? $("#"+linkId) : $(".popover_button");
    button.popover("hide");
    //replacing the button with a clone of itself solves the problem where
    //once the popover is initialized, you can't change it's content. This way,
    //the button is replaced with a clone of itself, but without the already
    //initialized popover
    button.replaceWith(button.clone());
    e.preventDefault();
  });
  styleFileInputs();

  var timer = null;
  $("#search_query").keyup(function(){
    clearTimeout(timer);
    timer = setTimeout(quickSearch, 750);
  });
  $("#search_query").blur(function(){
    setTimeout(function(){
      $("#quick_search").slideUp();
    }, 500);
  });
  
  if (!Modernizr.input.placeholder) {
      $("#search_keywords").placeholder();
  }
  
  $(".scrollPane").jScrollPane();

  $(".linked_item").click(function(e){
    if(!$(this).closest(".editable").hasClass("edit"))
      window.location = $(this).data("rel");
    else
      e.preventDefault();
  });
  
  $("#search_keywords").autocomplete({
    source: function(request, response) {
      $.ajax({
        url: '/searches/autocomplete.json',
        dataType: 'json',
        data: {keywords: $("#search_keywords").val() },
        success: function(data) {
          response(data);
        }
      });
    },
    select: function(e, ui) {
      window.location.href = ui.item.url;
    }
  });
  
  $("#gpa_section a.help, #rating a.help").live('click', function(){
    return false;
  });
});
