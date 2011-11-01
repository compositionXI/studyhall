class landingPage

  setup: ->
    @transitions = Modernizr.csstransitions
    @animations = Modernizr.cssanimations
    
    @speed = 1000
  
    @awesome = $('.awesome-landing')
    
    #header elements
    @header = $('.header', @awesome)
    @headerElements = $('h1, .login-button, .browser-quad, .browser-main', @header)
    @header_h1 = $('h1', @header)
    @header_login = $('.login-button', @header)
    @header_quad = $('.browser-quad', @header)
    @header_main = $('.browser-main', @header)
    @header_video = $('video', @header).mediaelementplayer(
        defaultVideoWidth: 383
        defaultVideoHeight: 313
        loop: true
        enableAutosize: false
        features: []
    )
    # $('.mejs-controls', @header).css('display', 'none')
    
    #Sign-up Form
    @form = $('#new_user')
    @form_submit = $("input[type='submit']", @form)
    
    #reasons elements 
    @reasons = $('.reasons').data('state', 'closed') 
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
      defaultVideoWidth: 700
      defaultVideoHeight: 393
      features: ['playpause','progress','current','duration','tracks','volume']
    )
    @video_container = $('.mejs-container', @reasons) || @video 
    $('.mejs-overlay', @video_container).remove()
    
    #Startup the page
    @animateHeader()
    @header_video[0].player.play()
    @reasons_h1.add(@reasons_close).click (e) => 
      @animateReasons()
      e.preventDefault()
    @postitSetup()
    
  #Post-its animations
  postitSetup: ->
    that = this
    @reasons_content.mouseleave ->
      $(this).unbind('mouseleave')
      that.postits.each ->
        $(this).mouseenter ->
          $(this).unbind('mouseenter') 
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
  
  animateHeader: ->
    if @transitions
      @headerElements.addClass 'drop'
    else
      window.setTimeout =>  
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
      , @speed     
      
  animateReasons: ->  
    if @reasons.data('state') == 'closed' 
      @header_video[0].player.pause()
      if @transitions
        @awesome.addClass 'open'
      else
        @reasons_header.addClass('up')
        @reasons_content.stop().animate
          'height' : 700
        , @speed
      
      @reasons.data('state' , 'open')
      @scroll()    
    else
      @header_video[0].player.play()
      if @transitions
        @awesome.removeClass 'open'
      else
        @reasons_header.removeClass('up')
        @awesome.animate
          'margin-top' : '0'
        , @speed 
        @reasons_content.animate
          'height' : 0
        , @speed
      @reasons.data('state' , 'closed')
      @postitCleanup()
  
  scroll: ->
    $body = $('body')
    $html = $('html')
    
    if $body.scrollTop() != 0 and $html.scrollTop() == 0
      element = $body
    else
      element = $html
    
    if @animations  
      element.animate
        scrollTop : 0
      , @speed
    else 
      element.animate
        scrollTop : 0
        'margin-top' : '-570px'
      , @speed
  
  formValidation: (element) ->
    @form.find(".input_field").each ->
      input = $(element)
      if input.twipsy(true) != null
        input.twipsy("hide")
   
$ -> 
  landing = new landingPage  
  if $('body').hasClass('home-landing_page')
    landing.setup()
  
    landing.form_submit.click ->
      landing.formValidation(this)