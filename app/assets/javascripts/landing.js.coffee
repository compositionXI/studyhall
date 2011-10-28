class landingPage

  setup: ->
    @body = $('body')
    @landing = $('.awesome-landing')
    @supportTransitions = Modernizr.csstransitions
    
    @headerElements = $('header h1, .login-button, .browser-quad, .browser-main', @landing)
    
    # @reasons = $('.reasons')
    # @reasons.h1 = $reasons.find('h1')
    
    @browser_main = $('.browser-main', @landing)
    
  animateHeader: ->
    if @supportTransitions
      @headerElements.addClass 'drop'

$ -> 
  landing = new landingPage
  
  landing.setup()
  landing.animateHeader()
  
   
  #TEST CODE
  $('li').click (e) ->
    $(@).toggleClass('hinge-fall-right') 
    return undefined