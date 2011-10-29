class landingPage

  setup: ->
    # @supportTransitions = Modernizr.csstransitions
    @supportTransitions = false
  
    @awesome = $('.awesome-landing')
    @header = $('.header', @awesome)
    @headerElements = $('h1, .login-button, .browser-quad, .browser-main', @header)
    @header_h1 = $('h1', @header)
    @header_login = $('.login-button', @header)
    @header_quad = $('.browser-quad', @header)
    @header_main = $('.browser-main', @header) 
    @reasons = $('.reasons')
    @reasonsh1 = $('h1', @reasons)    
    @browser_main = $('.browser-main', @landing)
    
    if @supportTransitions
      @animateHeaderCSS()
      @reasonsh1.click (e) -> 
        @animateReasons(this)
    else
      window.setTimeout =>  
        @animateHeader()  
      , 100
      
  animateHeader: ->
    @header_h1.animate
      'top' : 57
    , 500
    @header_login.animate
      'top' : 15
    , 500
    @header_quad.animate
      'bottom' : 10
    , 650
    @header_main.animate
      'bottom' : "-10px"
    , 750
  
  animateHeaderCSS: ->
    @headerElements.addClass 'drop'
  
  animateReasonsCSS: (element) ->
    if @supportTransitions
       @awesome.toggleClass 'open' 

$ -> 
  landing = new landingPage  
  landing.setup()  