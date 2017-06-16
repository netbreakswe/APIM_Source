'use strict';

angular.module('APIM.ricarica_crediti')

.controller('ricarica_crediti_ctrl', function($scope, $http) {
	
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
	
	$scope.updateCredits = function() {
		$http.post("http://localhost:8101/credits_update?IdClient=" + localStorage.getItem("IdClient") + "&Credits=" + 100).then(function(response) {
			console.log("Ciao");
			window.location.reload();
		});
	};
	
});