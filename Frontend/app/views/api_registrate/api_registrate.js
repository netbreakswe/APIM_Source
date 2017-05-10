'use strict';

angular.module('APIM.api_registrate', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/api_registrate', {
    templateUrl: 'views/api_registrate/api_registrate.html',
    controller: 'api_registrate_ctrl'
  });
}])

.controller('api_registrate_ctrl', function($scope, $http) {

  
});