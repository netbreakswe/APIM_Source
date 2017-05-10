'use strict';

angular.module('APIM.api_registrate')

.controller('api_registrate_ctrl', function($scope, $http) {
	$scope.ms = [];

	$http.get("http://localhost:8121/retrieve_ms_by_developerId?Id="+localStorage.getItem("IdClient"))
	.then(function(response1) {
		$scope.ms = response1.data.IdMS;
    });

  
});