'use strict';

angular.module('APIM.admin_home')

.controller('admin_home_ctrl', function($scope, $http, $location) {
	
	if(localStorage.getItem("Session") != 'Admin') {
		$location.path("!#");
	};
 
});