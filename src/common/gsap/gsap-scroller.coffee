# coffeelint: disable=max_line_length

angular.module('scrollTest', [])


.directive 'scrollerTest', ->
  restrict: 'A'
  link: (scope, element, attrs, ctrl) ->
    console.log 'afgdsfsg'
    gazastrip = {}

    gazastrip.blockHeight = $(window).outerHeight()
    gazastrip.blockWidth = $(window).outerWidth()

    console.log gazastrip

    $(".container").css({
      height: gazastrip.blockHeight
    })

    $(".view-wrapper").css({
      width: 3*gazastrip.blockWidth
    })

    $(".view").css({
      width: gazastrip.blockWidth
    })

    $(".body-wrapper").niceScroll({
      touchbehavior: true,
      overflowx:false,
    })

    $(".iscroll-2").niceScroll({
      touchbehavior:true,
      oneaxismousemode: false,
      overflowy: false,
    })


.service 'scrollAnimation', ->
  console.log 'scrollAnimation service'

  THROTTLE_MS = 30

  registerAnimation: (anim, scrollTarget, scrollRefElement, opts) -> _.defer ->
    anim.pause()

    console.log anim

    $scrollTarget = $(scrollTarget)

    offset = Math.abs($scrollTarget.offset().top - scrollRefElement.offset().top)/$scrollTarget.height()
    offset = Math.min offset, 1

    lastOffset = offset
    to = null

    $scrollTarget.on 'scroll', ->
      clearTimeout to
      to = setTimeout ->
        console.log 'scroll stop'
        anim.pause()
      , 100
      handleScroll()

    handleScroll = _.throttle ->

      offset = Math.abs($scrollTarget.offset().top - scrollRefElement.offset().top)/$scrollTarget.height()
      offset = Math.min offset, 1

      if offset == 1
        if lastOffset != 1
          anim.seek(0)
        lastOffset = offset
        return

      anim.pause()

      timeProgress = anim._time/anim._totalDuration

      coef = Math.abs(lastOffset - offset) / (THROTTLE_MS/1000)
      if timeProgress > (1 - offset) * 1.1
        coef = coef / 2
      if timeProgress < (1 - offset) * 0.9
        if offset < 0.15 or offset > 0.85
          factor = 6
        else
          factor = 2
        if lastOffset - offset < 0
          # Animation is running back, so we need to slow down.
          coef = coef / factor
        else
          coef = coef * factor

      anim.timeScale coef
      if lastOffset - offset < 0
        anim.reverse()
      else
        anim.play()
      anim.resume()

      console.log 'progress', offset.toFixed(3), anim._time.toFixed(3)

      lastOffset = offset

      #anim.seek offset
    , THROTTLE_MS
