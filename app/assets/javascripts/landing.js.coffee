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
    @reasons_header = $('header', @reasons)
    @reasons_h1 = $('h1', @reasons) 
    @reasons_close = $('#close_reasons')   
    @reasons_content = $('.content', @reasons)
    
    #Post-its
    @postits = $('.postits li', @reasons)
    @postit_count = 0
    @postit_classes = ['hinge-fall-left','hinge-fall-right']
        
    #Video       
    @video = $('#studyhall_video', @awesome).mediaelementplayer(
      features: ['playpause','progress','current','duration','tracks','volume']
    )
    @video_container = $('.mejs-container') || @video 
          
    if @supportTransitions
      @animateHeaderCSS()
      @reasons_h1.click (e) => 
        @animateReasonsCSS()
    else
      window.setTimeout =>  
        @animateHeader()  
      , @speed 
      @reasons_h1.toggle @openReasons, @closeReasons
  
  #Post-its animations
  postitSetup: ->
    that = this
    @reasons_close.click (e) ->
      @closeReasons
      e.preventDefault()
    @reasons_content.mouseleave ->
      $(this).  unbind('mouseleave')
      that.postits.each ->
        $(this).mouseenter -> 
          that.animatePostit(this)
          
  postitCleanup: ->
    that = this
    # @postits.removeClass(@postit_classes)
    @video[0].pause()  
  
  animatePostit: (element) ->
    that = this
    $postit = $(element)
    rand = Math.floor(Math.random() * 2)  
    $postit.addClass(that.postit_classes[rand]).delay(1200).fadeOut 300, ->
      that.postit_count++
      if that.postit_count == 8
        that.video_container.animate
          opacity: 100
        , 1000, ->
        that.video[0].player.play()
  
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
    @postitSetup()
    @reasons_header.addClass('up')
    @scroll()   
    @reasons_content.stop().animate
      'height' : 700
    , @speed
  
  closeReasons: =>
    @postitCleanup()
    @reasons_header.removeClass('up')
    @awesome.animate
      'margin-top' : '0'
    , @speed 
    @reasons_content.animate
      'height' : 0
    , @speed  
  
  scroll: ->
    $('body').animate
      scrollTop : 0
      'margin-top' : '-570px'
    , @speed
    
$ -> 
  landing = new landingPage  
  landing.setup()