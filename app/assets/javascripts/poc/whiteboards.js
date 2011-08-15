$(document).ready(function(){
  var wb = $("#whiteboard");
  if(wb.hasClass("fadein"))
    wb.delay(500).animate({
      opacity: 1.0
    }, 1000, function(){
      // animation complete
    });
  else
    wb.css({opacity:"1"});
});
