class landingPage

  setup: ->
    @supportTransitions = Modernizr.csstransitions
    
    @awesome = $('.awesome-landing')
    @header = $('.header', @awesome)
    @headerElements = $('h1, .login-button, .browser-quad, .browser-main', @header)    
    
    @reasons = $('.reasons')
    @reasonsh1 = $('h1', @reasons)
    
    @reasonsh1.click (e) => 
      @animateReasons()  
    
    @browser_main = $('.browser-main', @landing)
    
  animateHeader: =>
    if @supportTransitions
      @headerElements.addClass 'drop'
  
  animateReasons: =>
    if @supportTransitions
       @awesome.toggleClass 'open'
       $('html, body').stop().animate(
         scrollTop: 0
       , 1000,'easeInOutExpo');
       # debugger

$ -> 
  landing = new landingPage
  
  landing.setup()
  landing.animateHeader()
  
   
  #TEST CODE
  $('li').click (e) ->
    $(@).toggleClass('hinge-fall-right') 
