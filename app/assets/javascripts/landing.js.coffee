class landingPage

  setup: -> 
    self = this
    @transitions = Modernizr.csstransitions
    @animations = Modernizr.cssanimations
    
    @speed = 1000
  
    @landing = $('#landing')
    
    #header elements
    @header = $('.header', @landing)
    # @headerElements = $('h1, .login-button, .browser-quad, .browser-main', @header)
    @headerElements = $('h1, .browser-quad, .browser-main', @header) 
    @header_h1 = $('h1', @header)
    # @header_login = $('.login-button', @header)
    @header_login = $()
    @header_quad = $('.browser-quad', @header)
    @header_main = $('.browser-main', @header)
   
    #Sign-up Form 
    @signup = $('.signup')
    @form = $('#new_user', @signup)
    @form_submit = $("input[type='submit']", @form)
    @form_prefix = $('.url-prefix', @form)
    @info_message = $('#info_message', @signup)
    @success_message = $('#success_message', @signup)
    
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
         
    #Startup the page
    @animateHeader() 
    @reasons_h1.add(@reasons_close).click (e) => 
      @animateReasons()
      e.preventDefault()  
    
    @postitSetup()
    
    #Form Setup
    @form_prefix.click ->
      $(this).siblings('.input_field').focus()    
    
    #Client-side validation so they don't have to wait for a server response
    @form.validate
      errorPlacement: (error, element) ->
        $(element)
          .attr('title', error.text())
          .twipsy({placement: "below",trigger: "manual", animate: false, offset: 2})
          .twipsy('show')
      unhighlight: (element, errorClass) ->
        $(element).twipsy('hide')  
      rules:
        'user[password]':
          required: true
          minlength: 4
      messages: 
        'user[email]': "Email is invalid"
        'user[password]':
          required: "Password is invalid"
          minlength: "Password must be at least 4 characters"
        'user[custom_url]': "URL is invalid"
    #Hook in to the rails.js events to hide the form and provide an interstitial (info) message.  
    @form
      .bind 'ajax:beforeSend', ->
        self.form.removeClass('in')
        self.info_message.addClass('in')       
  
  headerVideoSetup: ->
    self = this 
    @header_video = $('video', @header).mediaelementplayer
      defaultVideoWidth: 383
      defaultVideoHeight: 313
      loop: true
      features: ['playpause']
      enableAutosize: false
      success: (mediaElement, domElement) -> 
        $('.mejs-layers, .mejs-controls', self.header).remove()
        $('.mejs-container', @header).fadeIn 1000, ->
          mediaElement.play()
   
  reasonsVideoSetup: ->
    self = this      
    @reasons_shim = $('.video_shim', @reasons)
    @reasons_video = $('#studyhall_video', @landing).mediaelementplayer
      defaultVideoWidth: 700
      defaultVideoHeight: 393
      startVolume: 0.4
      features: ['playpause','progress','current','duration','tracks','volume']                                                                 
    @video_container = $('.mejs-container', @reasons) || @reasons_video 
    

  #Post-its animations
  postitSetup: ->
    self = this 
    @reasonsVideoSetup()
    @reasons_content.mouseleave ->
      $(this).unbind('mouseleave')
      self.postits.each ->
        $(this).mouseenter ->
          $(this).unbind('mouseenter') 
          self.animatePostit(this) 
          
  postitCleanup: ->
    self = this
    @reasons_video[0].player.pause()  
  
  animatePostit: (element) ->
    self = this
    $postit = $(element)
    
    if @animations
      $postit.bind("animationend webkitAnimationEnd MSAnimationEnd oAnimationEnd", (e) ->        
        $(this).hide()
      )
      rand = Math.floor(Math.random() * 2)  
      $postit.addClass(self.postit_classes[rand])
    else 
      $postit.animate
        top: parseInt($postit.css('top'), 10) + 700
      , 1500, 'swing', ->
        $postit.fadeOut 300
    
    self.postit_count++
    
    if self.postit_count == 8
      self.video_container.animate
        opacity: 100
      , @speed, ->
      self.reasons_shim.hide()  
      self.reasons_video[0].player.play()  
  
  animateHeader: ->
    if @transitions
      @headerElements.addClass 'drop'
      @header_main.bind("transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", (e) =>        
        @headerVideoSetup()
      )
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
        , 750, 'swing', ->
          @headerVideoSetup()  
      , @speed     
      
  animateReasons: ->  
    if @reasons.data('state') == 'closed' 
      @header_video.trigger('pause')
      if @transitions
        @landing.addClass 'slide-open'
      else
        @reasons_header.addClass('up')
        @landing.animate
          'margin-top' : '-570px'
        , @speed
        @reasons_content.stop().animate
          'height' : 700
        , @speed   
      @reasons.data('state' , 'open')
      @scroll()    
    else
      @header_video.trigger('play')
      if @transitions
        @landing.removeClass 'slide-open'
      else
        @reasons_header.removeClass('up')
        @landing.animate
          'margin-top' : '0'
        , @speed 
        @reasons_content.animate
          'height' : 0
        , @speed
      @reasons.data('state' , 'closed')
      @postitCleanup()
  
  formValidation: (element) ->
    @form.find(".input_field").each ->
      input = $(element)
      if input.twipsy(true) != null
        input.twipsy("hide")  
  
  scroll: ->
    $('html, body').animate(
         scrollTop : 0
       , @speed)
   
$ -> 
  landing = new landingPage  
  if $('body').hasClass('home-landing_page')
    landing.setup()
    landing.form_submit.click ->
      landing.formValidation(this) 
        