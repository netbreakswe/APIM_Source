'use strict';

angular.module('APIM.admin_api_detail')

.controller('admin_api_detail_ctrl', function($scope, $routeParams, $http, $location) {

	var apiId = $routeParams.apiId;

	/* Questo pezzo va configurato con il servizio
	$http.get("http://localhost:8100/homepage_ms_list?" + apiId).then(function(response) {
        $scope.api = response.data;
    });
	*/

		//provvisorio fino a quando non va il servizio
	  var apis = [{ 
	  				id:13, 
	  				nome: "Trekker",   
	  				autore: "Rakr",  
	  				policy: "A chiamata", 
	  				licenzeAttive: 325,
	  				utentiConLicnzaAttiva: 280,
	  				chimatePerDay: 32154,
	  				tempoMedioUtilizzo: 9800,
	  				trafficoMedioUtilizzo: 328,
	  				utentiConLicnzaAttiva: 236,
	  				tempoMedioRisposta: 123
	  			}];

	  $scope.api = apis[0];



	  $scope.sospendi_api = function () {
	  	alert($scope.api.id)
	  }

	  $scope.cancella_api = function () {
	  	alert($scope.api.id);
	  	$location.path("/login");
	  }



});