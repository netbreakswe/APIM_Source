'use strict';

angular.module('APIM.diventa_sviluppatore')

.controller('diventa_sviluppatore_ctrl', function($scope, $http, $location) {
	
	if(localStorage.getItem("Session") != 'true') {
		$location.path("!#");
	};
	
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
		
		if( localStorage.getItem("ClientType") == 2 ) {
			$location.path("/account");
		}
		else {
			
			$http.post("http://localhost:8101/developer_upgrade?Id="+localStorage.getItem("IdClient")).then(function(response) {
				
				localStorage.setItem("ClientType", 2);
				
				// calcola data oggi
				var today = new Date();
				var dd = today.getDate();
				var mm = today.getMonth()+1;
				var yyyy = today.getFullYear();
				if(dd<10) {
					dd='0'+dd;
				};
				if(mm<10) {
					mm='0'+mm;
				};
				$scope.Timestamp = dd+'/'+mm+'/'+yyyy;
				
				function generateUUID() {
					var d = new Date().getTime();
					if(typeof performance !== 'undefined' && typeof performance.now === 'function') {
						d += performance.now(); // use high-precision timer if available
					}
					
					var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
					var r = (d + Math.random()*16)%16 | 0;
					d = Math.floor(d/16);
					return (c=='x' ? r : (r&0x3|0x8)).toString(16);
					});

					return uuid;
				};
				
				$scope.IdPurchase = generateUUID();
					
				// chiamata esemplificativa, non si dovrebbe utilizzare un purchase
				$http.post("http://localhost:8131/purchase_registration?" +
					"IdPurchase=" + $scope.IdPurchase +
					"&APIKey=" + "Questo campo non dovrebbe esserci" +
					"&IdClient=" + localStorage.getItem("IdClient") +
					"&Timestamp=" + $scope.Timestamp +
					"&Amount=" + "Questo campo pure non dovrebbe esserci" +
					"&Type=" + "Promosso a Sviluppatore"
				).then(function(response) {
						
					window.location.reload();
					$location.path("/conferma_diventa_sviluppatore");
					
				})
				
			});
		}
	}
	
});