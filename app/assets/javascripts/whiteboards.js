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

  $("body").delegate("a.selector","click",function(e){
    link = $(this);
    if(link.hasClass("all")){
      link.parent().find("input[type=checkbox]").prop("checked",true);
    }else if(link.hasClass("none")){
      link.parent().find("input[type=checkbox]").prop("checked",false);
    }else
      true;
      //do nothing
    e.preventDefault();
  });
});
