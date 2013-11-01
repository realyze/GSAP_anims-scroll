# coffeelint: disable=max_line_length

angular.module('salsita.scroller2', [])

.directive 'scroller', ($timeout) ->
  restrict: 'A'
  link: (scope, element, attrs, ctrl) ->

    console.log 'scroller up'

    timeout = null
    $timeout ->
      $('#foobar').css('-webkit-animation-play-state', 'paused')
    , 0

    down = true

    $('html').on 'mousewheel DOMMouseScroll wheel', (event) ->

      event.preventDefault?()

      if timeout
        clearTimeout timeout

      if not down and event.originalEvent.wheelDeltaY < 0
        down = true
        #$('#foobar').css('-webkit-animation-direction', 'reverse')
        revert down
      else if down and event.originalEvent.wheelDeltaY > 0
        down = false
        #$('#foobar').css('-webkit-animation-direction', 'normal')
        revert down

      $('#foobar').css('-webkit-animation-play-state', 'running')

      timeout = setTimeout ->
        $('#foobar').css('-webkit-animation-play-state', 'paused')
      , 100


revert =  (down) ->
  keyframes = findKeyframesRule('foobar')

  #$('#foobar')[0].classList.remove('foobar')

  a = keyframes.cssRules[0].cssText
  b = keyframes.cssRules[1].cssText

  #console.log 'reverting', a, b
  #console.log 'not reverted', keyframes.cssRules[0].cssText, keyframes.cssRules[1].cssText

  ###
  keyframes.deleteRule('0%')
  keyframes.deleteRule('100%')

  if down
    console.log 'down'
    keyframes.insertRule("100%#{a.slice(a.indexOf(' '))}", 1)
    keyframes.insertRule("0%#{b.slice(b.indexOf(' '))}", 0)
  else
    console.log 'up'
    keyframes.insertRule("0%#{a.slice(a.indexOf(' '))}", 0)
    keyframes.insertRule("100%#{b.slice(b.indexOf(' '))}", 1)
  ###

  if not down
    $('#foobar')[0].style.webkitAnimationName = 'foobar2'
    #$('#foobar').css('-webkit-animation', 'foobar2')
  else
    $('#foobar')[0].style.webkitAnimationName = 'foobar'
    $('#foobar').css('-webkit-animation', 'foobar')


  $('#foobar')[0].offsetWidth = $('#foobar')[0].offsetWidth


  #$('#foobar')[0].classList.add('foobar2')
  #console.log 'reverted', keyframes.cssRules[0].cssText, keyframes.cssRules[1].cssText


findKeyframesRule = (rule) ->
  # gather all stylesheets into an array
  ss = document.styleSheets

  # loop through the stylesheets
  i = 0

  while i < ss.length
    # loop through all the rules
    j = 0

    while j < ss[i].cssRules?.length
      # find the -webkit-keyframe rule whose name matches our passed over parameter and return that rule
      return ss[i].cssRules[j] if ss[i].cssRules[j].type is window.CSSRule.WEBKIT_KEYFRAMES_RULE and ss[i].cssRules[j].name is rule
      ++j
    ++i
  # rule not found
  null
