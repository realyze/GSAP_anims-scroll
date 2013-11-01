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

  THROTTLE_MS = 25

  registerAnimation: (anim, scrollTarget, scrollRefElement, opts) ->
    anim.pause()

    console.log anim

    $scrollTarget = $(scrollTarget)

    lastOffset = null
    to = null

    $scrollTarget.on 'scroll', ->
      clearTimeout to
      to = setTimeout ->
        console.log 'scroll stop'
        anim.pause()
      , 100
      handleScroll()

    handleScroll = _.throttle ->
      anim.pause()

      offset = Math.abs($scrollTarget.offset().top - scrollRefElement.offset().top)/$scrollTarget.height()
      offset = Math.min offset, 1

      if lastOffset is null or offset == 1
        lastOffset = offset
        return

      coef = Math.abs(lastOffset - offset) / (THROTTLE_MS/1000) /1.5

      ###if Math.abs((1 - offset) - anim._time/anim._totalDuration) > 0.3
        console.log 'aaa'
        coef = coef * 1.2###

      anim.timeScale coef
      if lastOffset - offset < 0
        anim.reverse()
      else
        anim.play()
      anim.resume()

      lastOffset = offset

      #anim.seek offset
    , THROTTLE_MS
