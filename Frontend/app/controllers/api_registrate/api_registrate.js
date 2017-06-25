'use strict';

angular.module('APIM.api_registrate')

.controller('api_registrate_ctrl', function($scope, $http, $rootScope) {
	
	if(localStorage.getItem("Session") != 'true') {
		$location.path("!#");
	};

	// inizializza lista servizi
	$scope.services = [];
	// inizializza lista licenze attive
	$scope.activelicenses = [];
	// inizializza lista guadagni desiderati dal developer
	$scope.devprofits = [];
	// inizializza lista guadagni del mese attuale
	$scope.monthprofits = [];
	// inizializza lista guadagni totali
	$scope.profits = [];
	
	// recupera i microservizi registrati dal developer
	$http.post("http://localhost:8121/retrieve_ms_from_developerid?Id="+localStorage.getItem("IdClient")).then(function(response) {
		if(response.data.msdevdata) {
			for(var i=0; i<response.data.msdevdata.length; i++) {
				$scope.services.push({
					IdMS: response.data.msdevdata[i].IdMS,
					Name: response.data.msdevdata[i].Name,
					Logo: response.data.msdevdata[i].Logo,
					IsActive: response.data.msdevdata[i].IsActive,
				});
				$scope.devprofits[response.data.msdevdata[i].IdMS] = response.data.msdevdata[i].Profit;
			}
		}
	}).then(function(response) {
		for(var i=0; i<$scope.services.length; i++) {
			// recupera il numero di licenze attive della API a partire dall'id
			$http.post("http://localhost:8131/retrieve_active_apikey_number_from_msid?Id="+$scope.services[i].IdMS).then(function(response) {
				if(response.data) {
					$scope.activelicenses[response.data.IdMS] = response.data.Licenses;
				}
			});
			$http.post("http://localhost:8131/retrieve_monthly_purchases_sum_from_msid?Id="+$scope.services[i].IdMS).then(function(response) {
				if(response.data) {
					$scope.monthprofits[response.data.IdMS] = (response.data.Sum * $scope.devprofits[response.data.IdMS]) / 100;
				}
			});
			$http.post("http://localhost:8131/retrieve_purchases_sum_from_msid?Id="+$scope.services[i].IdMS).then(function(response) {
				if(response.data) {
					$scope.profits[response.data.IdMS] = (response.data.Sum * $scope.devprofits[response.data.IdMS]) / 100;
				}
			});
		}
	});
	
	// recupera i crediti ed il tipo dell'utente
	$http.post("http://localhost:8101/retrieve_client_info?Id="+localStorage.getItem("IdClient")).then(function(response) {
		$scope.Credits = response.data.Credits;
		
		if(response.data.ClientType == 1) {
			$scope.ClientType = "Basic";
		}
		else if(response.data.ClientType == 2) {
			$scope.ClientType = "Developer";
		}
		else {
			$scope.ClientType = "Error";
		}
	});
  
});