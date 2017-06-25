'use strict';

angular.module('APIM.visualizza_sla_api')

.controller('visualizza_sla_api_ctrl', function($scope, $http, $routeParams) {
	
	if(localStorage.getItem("Session") != 'true') {
		$location.path("!#");
	};
	
	$http.post("http://localhost:8121/retrieve_ms_info?Id="+$routeParams.api_id).then(function(response) {
			$scope.IdMS = $routeParams.api_id;
			$scope.Name = response.data.Name;
			$scope.Logo = response.data.Logo;
	})
	
	$scope.limit = 10;
	
	$scope.calls = [];
	
	// recupera la lista delle ultime chiamate effettuate
	$http.post("http://localhost:8141/retrieve_calls_list_from_msid?Id="+$routeParams.api_id).then(function(response) {
		for(var i=0; i<response.data.callslist.length; i++) {
			$scope.calls.push({
				IdSLASurvey: response.data.callslist[i].IdSLASurvey,
				Timestamp: response.data.callslist[i].Timestamp,
				ResponseTime: response.data.callslist[i].ResponseTime,
				IsCompliant: response.data.callslist[i].IsCompliant
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