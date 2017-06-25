'use strict';

angular.module('APIM.api_acquistate')

.controller('api_acquistate_ctrl', function($scope, $http) {
	
	if(localStorage.getItem("Session") != 'true') {
		$location.path("!#");
	};
	
	$scope.servicesid = [];
	$scope.servicesname = [];
	$scope.serviceslogo = [];
	$scope.servicesisactive = [];
	$scope.servicesidpolicy = [];

	// recupera gli id dei microservizi con licenze attive dell'utente attuale
	$http.get("http://localhost:8131/retrieve_mslist_from_clientid?Id="+localStorage.getItem("IdClient")).then(function(response) {
		if(response.data.msremaininglist) {
			for(var i=0; i<response.data.msremaininglist.length; i++) {
				$scope.servicesid.push({
					APIKey: response.data.msremaininglist[i].APIKey,
					IdMS: response.data.msremaininglist[i].IdMS,
					Remaining: response.data.msremaininglist[i].Remaining
				});
			}
		}
	}).then(function(response) {
		for(var i=0; i<$scope.servicesid.length; i++) {
			// recupera i dati dei microservizi ottenuti dalla lista degli id appena recuperata
			$http.post("http://localhost:8121/retrieve_ms_info?Id="+$scope.servicesid[i].IdMS).then(function(response) {
				if(response.data) {
					$scope.servicesname[response.data.IdMS] = response.data.Name;
					$scope.serviceslogo[response.data.IdMS] = response.data.Logo;
					$scope.servicesisactive[response.data.IdMS] = response.data.IsActive;
					$scope.servicesidpolicy[response.data.IdMS] = response.data.Policy;
				}
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
	
	
	$scope.getNewAPIKey = function(oldapikey,idms) {
		
		function generateUUID() {
			var d = new Date().getTime();
			if(typeof performance !== 'undefined' && typeof performance.now === 'function') {
				d += performance.now(); // use high-precision timer if available
			};
							
			var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
				var r = (d + Math.random()*16)%16 | 0;
				d = Math.floor(d/16);
				return (c=='x' ? r : (r&0x3|0x8)).toString(16);
			});

			return uuid;
		};
		
		var newapikey = generateUUID();
		
		$http.post("http://localhost:8131/apikey_update?OldAPIKey="+oldapikey+"&NewAPIKey="+newapikey).then(function(response) {
			document.getElementById("newapikey"+idms).style.display = "none";
			window.prompt("Copia la nuova APIKey: Ctrl+C, Enter", newapikey);
		});
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