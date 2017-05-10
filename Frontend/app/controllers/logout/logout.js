'use strict';

angular.module('APIM.logout')

.controller('logout_ctrl', function ($scope, $rootScope, $location) {
	localStorage.removeItem("Session");
	localStorage.removeItem("IdClient");
	localStorage.removeItem("Name");
	localStorage.removeItem("Surname");
	localStorage.removeItem("Email");
    localStorage.removeItem("Password");
	localStorage.removeItem("Avatar");
	localStorage.removeItem("Credits");
	localStorage.removeItem("AboutMe");
	localStorage.removeItem("Citizenship");
	localStorage.removeItem("LinkToSelf");
	localStorage.removeItem("Paypal");

	$rootScope.loggedin = false;
    $rootScope.identity = null;
  }
);