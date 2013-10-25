# coffeelint: disable=max_line_length


toggleDirection = (tl) ->
  if tl.reversed()
    console.log 'reversed'
    tl.play()
  else
    console.log 'play'
    tl.reverse()

SCROLL_THROTTLE_MS = 50
TWEEN_LENGTH = 1000

angular.module('salsita.gsap-scroller', [])

.directive 'gsapScroller', ($timeout) ->
  restrict: 'A'
  link: (scope, element, attrs, ctrl) ->

    started = false
    scrollTimeout = null


    #TweenLite.set('#content', {perspective:500})

    tl = new TimelineMax({onComplete: -> console.log 'tween done'})
    tl.to("#content", TWEEN_LENGTH/1000, {'opacity': 0, ease: Power1.easeOut})
    tl.pause()


    handleScrollEnd = ->
      window.clearInterval scrollTimeout
      scrollTimeout = null
      tl.pause()
      console.log 'end'


    handleScrollStart = () ->
      scrollTimeout = scrollTimeout or (setInterval ->
        tl.pause()
        data = getScrollData $('#content'), $('#skroll')
        if not data then return

        [totalTime, down] = data

        if totalTime
          tl.timeScale TWEEN_LENGTH/totalTime
          if not down
            tl.reverse()
          else
            tl.play()
          tl.resume()
      , SCROLL_THROTTLE_MS)


    $timeout ->
      myScroll = new IScroll('#skroll', { scrollX: true, freeScroll: true })

      myScroll.on 'scrollStart', ->
        if started
          started = false
          handleScrollEnd()
          return
        started = true
        handleScrollStart()

      myScroll.on 'scrollEnd', ->
        if not started
          return
        started = false
        handleScrollEnd()

      console.log 'elems', $('#content'), $('#skroll')
    10

    return


lastOffsetPerc = 0
lastCenterOffset = null


getScrollData = do ->
  (el, scrollBody) ->
    #console.log 'el offset top', $(el).offset().top - scrollBody.offset().top

    scrollingDown = null

    elTop = el.offset().top - scrollBody.offset().top

    offsetPerc = (elTop / ($(el).height() - $(scrollBody).height())) * 100
    change = Math.abs(lastOffsetPerc - offsetPerc)
    scrollingDown = lastOffsetPerc > offsetPerc
    lastOffsetPerc = offsetPerc

    console.log 'change', change, offsetPerc

    if change == 0
      return null

    if offsetPerc > 100
      return null

    #if offsetPerc < 10
    #  return [10/offsetPerc, scrollingDown]

    #if lastCenterOffset is null
    #  lastCenterOffset = topOffset
    #  return

    totalTime = 100/change * SCROLL_THROTTLE_MS

    #console.log 'total comnpute', totalTime

    return [totalTime, scrollingDown]

