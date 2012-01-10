/* ===========================================================
 * bootstrap-popover.js v1.3.0
 * http://twitter.github.com/bootstrap/javascript.html#popover
 * ===========================================================
 * Copyright 2011 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================== */


!function( $ ) {

  var Popover = function ( element, options ) {
    this.$element = $(element)
    this.options = options
    this.enabled = true
    this.fixTitle()
  }

  /* NOTE: POPOVER EXTENDS BOOTSTRAP-TWIPSY.js
     ========================================= */

  Popover.prototype = $.extend({}, $.fn.twipsy.Twipsy.prototype, {

    setContent: function () {
      var $tip = this.tip()
      $tip.find('.title')[this.options.html ? 'html' : 'text'](this.getTitle())
      $tip.find('.content')[this.options.html ? 'html' : 'text'](this.getContent())
      if(this.options.help != undefined)
        $tip.find('.help')[this.options.html ? 'html' : 'text'](this.getHelp())
      $tip[0].className = 'popover'
    }

  , getContent: function () {
      var content
       , $e = this.$element
       , o = this.options

      if (typeof this.options.content == 'string') {
        content = $e.attr(o.content)
      } else if (typeof this.options.content == 'function') {
        content = this.options.content.call(this.$element[0])
      }
      return content
    }

  , getHelp: function () {
      var help
       , $e = this.$element
       , o = this.options

      if (typeof this.options.help == 'string') {
        help = $e.attr(o.help)
      } else if (typeof this.options.help == 'function') {
        help = this.options.help.call(this.$element[0])
      }
      return help
    }

  , showHelp: function () {
      var $tip = this.tip();
      var $help_div = $tip.find('.help');
      $help_div.css({height: $tip.find(".inner").height()+parseInt($tip.find(".inner").css("padding-top"))+parseInt($tip.find(".inner").css("padding-bottom"))});
      var width = $tip.find(".inner").width()+parseInt($tip.find(".inner").css("padding-left"))+parseInt($tip.find(".inner").css("padding-right"));
      if(this.options.placement == "left" || this.options.placement == "below-left")
        $help_div.animate({right: width});
      else
        $help_div.animate({left: width});
    }

  , hideHelp: function () {
      var $tip = this.tip();
      var $help_div = $tip.find('.help');
      if(this.options.placement == "left" || this.options.placement == "below-left")
        $help_div.animate({right: '0px'});
      else
        $help_div.animate({left: '0px'});
    }

  , tip: function() {
      if (!this.$tip) {
        if (this.options.help != undefined)
          this.$tip = $('<div class="popover" />')
            .html('<div class="arrow-border"></div><div class="arrow"></div><div class="help"></div><div class="inner"><div class="popover-header"><h3 class="title"></h3><a href="#" class="help_button">?</a></div><div class="content"><p></p></div></div>')
        else
          this.$tip = $('<div class="popover" />')
            .html('<div class="arrow-border"></div><div class="arrow"></div><div class="inner"><div class="popover-header"><h3 class="title"></h3></div><div class="content"></div></div>')
      }
      return this.$tip
    }

  })


 /* POPOVER PLUGIN DEFINITION
  * ======================= */

  $.fn.popover = function (options) {
    if (typeof options == 'object') options = $.extend({}, $.fn.popover.defaults, options)
    $.fn.twipsy.initWith.call(this, options, Popover, 'popover')
    return this
  }

  $.fn.popover.defaults = $.extend({} , $.fn.twipsy.defaults, { content: 'data-content', placement: 'right'})

}( window.jQuery || window.ender );
