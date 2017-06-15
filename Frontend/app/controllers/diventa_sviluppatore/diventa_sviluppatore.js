'use strict';

angular.module('APIM.diventa_sviluppatore')

.controller('diventa_sviluppatore_ctrl', function($scope, $http, $location) {
	
	// 1000 è impostato fisso anche nell'operation developer_upgrade di user_db, in caso sarà da cambiare anche lì
	$scope.CreditsNeeded = 1000;

	// recupera le informazioni dell'utente, compresi i crediti ed il tipo
	$http.post("http://localhost:8101/retrieve_client_info?Id="+localStorage.getItem("IdClient")).then(function(response) {
		$scope.IdClient = response.data.IdClient;
		$scope.Email = response.data.Email;
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
	
	$scope.enoughCredits = function() {
		if($scope.Credits >= $scope.CreditsNeeded) {
			return true;
		}
		else {
			return false;
		}
	};
	
	$scope.developerUpgrade = function() {
		$http.post("http://localhost:8101/developer_upgrade?Id="+localStorage.getItem("IdClient")).then(function(response) {
			localStorage.setItem("ClientType", 2);
			window.location.reload();
			$location.path("/conferma_diventa_sviluppatore");
		});
	}
	
});