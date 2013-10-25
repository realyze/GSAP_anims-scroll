# coffeelint: disable=max_line_length

angular.module( 'ngBoilerplate', [
  'templates-app'
  'templates-common'
  'ngBoilerplate.home'
  'ngBoilerplate.about'

  'ui.router'
  #'ui.state'

  'salsita.gsap-scroller'
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


.controller 'AppCtrl', ( $scope, $location, skrollrCenter, pageLoader ) ->
  skrollrCenter.init()
  pageLoader.init()

