# coffeelint: disable=max_line_length


toggleDirection = (tl) ->
  if tl.reversed()
    console.log 'reversed'
    tl.play()
  else
    console.log 'play'
    tl.reverse()

SCROLL_THROTTLE_MS = 25
TWEEN_LENGTH = 1000

angular.module('salsita.gsap-scroller', [])

.directive 'gsapScroller', ($timeout) ->
  restrict: 'A'
  link: (scope, element, attrs, ctrl) ->

    $timeout ->
      console.log 'skrollr'
      skrollr = window.skrollr.init(
        smoothScrolling: true
      )
      skrollr.on 'beforerender', ->
        console.log 'aaa'
        handleScroll()
    , 200


    console.log 'gsap-scroller'

    TweenLite.set('.container', {perspective:500})

    tl = new TimelineMax({onComplete: ->})

    tl.to(
      ".foobar", TWEEN_LENGTH/1000, {width: '1000px', ease: Power1.easeOut})

    tl.pause()

    lastScrollTop = $(window).scrollTop()
    scrollingDown = true

    lastOffset = 0
    lastCenterOffset = null

    handleScroll = _.throttle ->
      #console.log 'scrolling'
      el = $('.foobar')
      elCenter = el.offset().top + el.height() / 2
      windowCenter = $(window).scrollTop() + $(window).height() / 2

      centerOffset = Math.abs(elCenter - windowCenter)

      offset = centerOffset / ($(window).height() / 2) * 100
      change = Math.abs(lastOffset - offset)
      lastOffset = offset

      if offset > 100
        return

      if offset < 10
        tl.reverse()
        tl.timeScale(10/offset)
        return

      if lastCenterOffset is null
        lastCenterOffset = centerOffset
        return

      totalTime = 100/change * SCROLL_THROTTLE_MS

      tl.timeScale TWEEN_LENGTH/totalTime

      #console.log 'tween', offset, change, totalTime, tl.timeScale(), tl.progress()

      if lastCenterOffset > centerOffset
        # going to center
        if not tl.reversed()
          tl.reverse()
      else if tl.reversed()
        tl.play()

      tl.resume()

      lastScrollTop = $(window).scrollTop()
      lastCenterOffset = centerOffset

    , SCROLL_THROTTLE_MS

    timeout = null

    $('#scroll-me').on 'scroll', ->
      handleScroll()
      clearTimeout timeout
      timeout = setTimeout ->
        console.log 'stopped'
        tl.pause()
      , 100
