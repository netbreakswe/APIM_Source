'use strict';

angular.module('APIM.api_acquistate')

.controller('api_acquistate_ctrl', function($scope, $http) {
	
	$scope.servicesid = [];
	$scope.servicesname = [];
	$scope.serviceslogo = [];
	$scope.servicesisactive = [];
	$scope.servicesidpolicy = [];

	// recupera gli id dei microservizi con licenze attive dell'utente attuale
	$http.get("http://localhost:8131/retrieve_mslist_from_clientid?Id="+localStorage.getItem("IdClient")).then(function(response) {
		console.log("Length: "+response.data.msremaininglist.length);
		for(var i=0; i<response.data.msremaininglist.length; i++) {
			console.log("IdMs trovato: "+response.data.msremaininglist[i].IdMS);
			$scope.servicesid.push({
				IdMS: response.data.msremaininglist[i].IdMS,
				Remaining: response.data.msremaininglist[i].Remaining
			});
		}
	}).then(function(response) {
		for(var i=0; i<$scope.servicesid.length; i++) {
			// recupera i dati dei microservizi ottenuti dalla lista degli id appena recuperata
			$http.post("http://localhost:8121/retrieve_ms_info?Id="+$scope.servicesid[i].IdMS).then(function(response) {
				$scope.servicesname[response.data.IdMS] = response.data.Name;
				$scope.serviceslogo[response.data.IdMS] = response.data.Logo;
				$scope.servicesisactive[response.data.IdMS] = response.data.IsActive;
				$scope.servicesidpolicy[response.data.IdMS] = response.data.Policy;
			});
		}
	});
	
	// converte l'id della policy con il suffisso adatto (chiamate/millisecondi/byte)
	$scope.getRemainingSuffix = function(policyid) {
		if(policyid == 1) {
			return "chiamate";
		}
		else if(policyid == 2) {
			return "ms";
		}
		else if(policyid == 3) {
			return "byte";
		}
		else {
			return "error";
		}
	}
	
	/*
	$http.get("http://localhost:8121/retrieve_ms_from_developerid?Id="+localStorage.getItem("IdClient")).then(function(response) {
		for(var i=0; i<response.data.msdevdata.length; i++) {
			$scope.services.push({
				IdMS: response.data.msdevdata[i].IdMS,
				Name: response.data.msdevdata[i].Name,
				Logo: response.data.msdevdata[i].Logo,
				IsActive: response.data.msdevdata[i].IsActive
			});
		}
    });
	*/
	
	
	
	
	$scope.getNewAPIKey = function() {
		$scope.Math = window.Math;
		var key = "";
		var keylength = 8; // lunghezza APIKey
		var characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

		for(var i=0; i<keylength; i++) {
			key += characters.substr($scope.Math.floor(($scope.Math.random() * characters.length) + 1), 1);
			console.log(key);
		}
		alert("Chiave: "+key);
	}
	
	
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