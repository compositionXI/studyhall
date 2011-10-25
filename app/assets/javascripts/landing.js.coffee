$ -> 
  $body = $('body')
  $reasons = $('.reasons')
  $reasons.h1 = $reasons.find('h1')
  
  $reasons.h1.click (e) ->
    $body.toggleClass 'open'  
    
  #TEST CODE
  $('li').click (e) ->
    $(@).toggleClass('hinge-fall-right') 
    return undefined