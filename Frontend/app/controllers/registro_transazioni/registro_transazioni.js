'use strict';

angular.module('APIM.registro_transazioni')

.controller('registro_transazioni_ctrl', function($scope, $http) {
	
	$scope.purchases = [];
	
	// recupera la lista degli acquisti effettuati
	$http.post("http://localhost:8131/retrieve_purchases_list_from_userid?Id="+localStorage.getItem("IdClient")).then(function(response) {
		$scope.purchases.splice(0);
		for(var i=0; i<response.data.purchaseslist.length; i++) {
			$scope.purchases.push({
				IdPurchase: response.data.purchaseslist[i].IdPurchase,
				APIKey: response.data.purchaseslist[i].APIKey,
				Timestamp: response.data.purchaseslist[i].Timestamp,
				Amount: response.data.purchaseslist[i].Amount,
				Type: response.data.purchaseslist[i].Type
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