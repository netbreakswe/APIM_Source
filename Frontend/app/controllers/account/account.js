'use strict';

angular.module('APIM.account')

.controller('account_ctrl', function($scope, $http) {

		$scope.IdClient = localStorage.getItem("IdClient");
		$scope.Name = localStorage.getItem("Name");
		$scope.Surname = localStorage.getItem("Surname");
		$scope.Email = localStorage.getItem("Email");
		$scope.Password = localStorage.getItem("Password");
		$scope.Avatar = localStorage.getItem("Avatar");
		$scope.Credits = localStorage.getItem("Credits");
		$scope.AboutMe = localStorage.getItem("AboutMe");
		$scope.Citizenship = localStorage.getItem("Citizenship");
		$scope.LinkToSelf = localStorage.getItem("LinkToSelf");
		$scope.Paypal = localStorage.getItem("Paypal");

  
});