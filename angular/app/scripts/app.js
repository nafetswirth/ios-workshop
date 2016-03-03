'use strict';

/**
 * @ngdoc overview
 * @name niboDashboardApp
 * @description
 * # niboDashboardApp
 *
 * Main module of the application.
 */
angular
  .module('todoApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngSails',
    'ui.router',
    'smart-table',
    'ngTouch'
  ])
  .config(['$urlRouterProvider', '$stateProvider', function ($urlRouterProvider, $stateProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('index', {
        url: '/',
        templateUrl: '/views/main.html',
        controller: 'TaskListCtrl as vm',
        resolve: {
          tasks: ['$resource', function($resource) {
            return $resource('https://ios-workshop.herokuapp.com/task/:id', {id: '@id'}).query().$promise;
          }]
        }
      })
  }])
  .config(['$sailsProvider', function($sailsProvider) {
    //configure socket stuff
    $sailsProvider.url = 'https://ios-workshop.herokuapp.com';
}]);
