# coffeelint: disable=max_line_length

angular.module( 'salsitasoft', [
  'templates-app'
  'templates-common'
  'ngBoilerplate.home'
  'ngBoilerplate.about'

  'ui.router'
  #'ui.state'

  'scrollTest'
])

.value('$anchorScroll', angular.noop)

.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $locationProvider.html5Mode(true)

  $stateProvider.state 'page1',
    url: '/page1',
    views:
      current:
        controller: 'pageController',

  $stateProvider.state 'page2',
    url: '/page2',
    views:
      current:
        controller: 'pageController',


  $urlRouterProvider.otherwise '/page1'


.controller 'AppCtrl', ( $scope, $location, scrollAnimation ) ->
  cubic = (p) -> Math.pow p, 3
  tween = TweenLite.to $('.container:eq(2)'), 1, {opacity: 1}#, ease: (p) -> Math.pow p, 1.5}
  tween2 = TweenLite.to $('.flipshit'), 1, {
    x: -1 * $('.body-wrapper').width()/3
  }
  tween3 = TweenLite.to $('.rotateshit'), 1, {
    color: '#FF0000'
    rotation: 90
    ease: cubic
  }
  tween4 = TweenLite.to $('.rot-shit'), 1, {
    #scaleY: 5
    #scaleX: -0.5
  }

  scrollAnimation.registerAnimation tween, $('.body-wrapper'), $('.container:eq(2)')
  scrollAnimation.registerAnimation tween2, $('.body-wrapper'), $('.container:eq(2)')
  scrollAnimation.registerAnimation tween3, $('.body-wrapper'), $('.container:eq(2)')
  scrollAnimation.registerAnimation tween4, $('.body-wrapper'), $('.container:eq(3)')
