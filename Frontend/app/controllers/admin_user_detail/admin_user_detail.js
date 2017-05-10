'use strict';

angular.module('APIM.admin_user_detail')

.controller('admin_user_detail_ctrl', function($scope, $routeParams, $http, $location) {

	var apiId = $routeParams.apiId;

	/* Questo pezzo va configurato con il servizio
	$http.get("http://localhost:8100/homepage_ms_list?" + apiId).then(function(response) {
        $scope.user = response.data;
    });
	*/

		//provvisorio fino a quando non va il servizio
	  	$scope.user = { 
					idUtente:1, 
					nome: "Mark",   
					tipologia: "Sviluppatore",
					licenzeAttive: 13,
					apiEsposte: 35
	  			};



	  $scope.sospendi_utente = function () {
	  	alert($scope.user.nome)
	  }

	  $scope.sospendi_pagamenti = function () {
	  	alert($scope.user.nome);
	  }

	  $scope.sospendi_pagamenti = function () {
	  	alert($scope.user.nome);
	  }

});