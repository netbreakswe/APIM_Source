'use strict';

angular.module('APIM.api_acquistate')

.controller('api_acquistate_ctrl', function($scope, $http) {
	
	$scope.services = [];

	$http.get("http://localhost:8121/retrieve_ms_from_developerid?Id="+localStorage.getItem("IdClient")).then(function(response) {
		var i = 0;
		for (i; i < response.data.msdevdata.length; i++) {
			$scope.services.push({
				IdMS: response.data.msdevdata[i].IdMS,
				Name: response.data.msdevdata[i].Name,
				Logo: response.data.msdevdata[i].Logo,
				IsActive: response.data.msdevdata[i].IsActive
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