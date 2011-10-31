class landingPage

  setup: ->
    # @supportTransitions = Modernizr.csstransitions
    @supportTransitions = false
  
    @awesome = $('.awesome-landing')
    @speed = 1000
    
    #header elements
    @header = $('.header', @awesome)
    @headerElements = $('h1, .login-button, .browser-quad, .browser-main', @header)
    @header_h1 = $('h1', @header)
    @header_login = $('.login-button', @header)
    @header_quad = $('.browser-quad', @header)
    @header_main = $('.browser-main', @header)
    
    #reasons elements 
    @reasons = $('.reasons')
    @reasons_h1 = $('h1', @reasons)    
    @reasons_content = $('.content', @reasons)
    
    if @supportTransitions
      @animateHeaderCSS()
      @reasons_h1.click (e) => 
        @animateReasonsCSS()
    else
      window.setTimeout =>  
        @animateHeader()  
      , @speed 
      @reasons_h1.toggle @openReasons, @closeReasons
  
  
  #CSS3 Animations
  animateHeaderCSS: ->
    @headerElements.addClass 'drop'
    
  animateReasonsCSS: ->
    @scroll()
    @awesome.toggleClass 'open'
 
  #Pure JS Animations
  animateHeader: ->
    @header_h1.animate
      'top' : 57
    , 500
    @header_login.animate
      'top' : 15
    , 500
    @header_quad.animate
      'bottom' : -10
    , 650
    @header_main.animate
      'bottom' : "10px"
    , 750
   
  openReasons: =>
    @scroll()
    @awesome.animate
      'margin-top' : '-570px'
    , @speed     
    @reasons_content.stop().animate
      'height' : 700
    , @speed
  
  closeReasons: =>
    @awesome.animate
      'margin-top' : '0'
    , @speed 
    @reasons_content.animate
      'height' : 0
    , @speed  
  
  scroll: ->
    $('html').animate
      scrollTop : 0
    , @speed
    
$ -> 
  landing = new landingPage  
  landing.setup()