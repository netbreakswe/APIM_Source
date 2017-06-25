'use strict';

angular.module('APIM.gestione_api')

.controller('gestione_api_ctrl', function($scope, $http, $route, $mdDialog) {
	
	if(localStorage.getItem("Session") != 'Admin') {
		$location.path("!#");
	};

/*	$scope.servicesid = [];
	$scope.servicesname = [];
	$scope.serviceslogo = [];
	$scope.servicesisactive = [];
	$scope.servicesidpolicy = [];*/
	$scope.services = [];

	// recupera la lista di tutti microservizi con le informazioni da visualizzare nell'elenco
	$http.post("http://localhost:8121/retrieve_all_ms_info").then(function(response) {
		for(var i=0; i < response.data.services.length; i++) {
			$scope.services.push({
				Display: true,
				IdMS: response.data.services[i].IdMS,
				Name: response.data.services[i].Name,
				Description: response.data.services[i].Description,
				Version: response.data.services[i].Version,
				LastUpdate: response.data.services[i].LastUpdate,
				Developer: response.data.services[i].IdDeveloper,
				Logo: response.data.services[i].Logo,
				DocPDF: response.data.services[i].DocPDF,
				DocExternal: response.data.services[i].DocExternal,
				Profit: response.data.services[i].Profit,
				IsActive: response.data.services[i].IsActive,
				SLAGuaranteed: response.data.services[i].SLAGuaranteed,
				Policy: response.data.services[i].Policy
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

	// disattiva API
	$scope.disattivaAPI = function(IdMS) {
		$http.post("http://localhost:8121/change_isactive?IdMS=" + IdMS +"&IsActive=false").then(function(response) {
			if(response.data)
			{
				$route.reload();
			}
			else
			{
				alert("errore")
			}

	    });
	}

	// attiva API
	$scope.attivaAPI = function(IdMS) {
		$http.post("http://localhost:8121/change_isactive?IdMS=" + IdMS +"&IsActive=true").then(function(response) {
			if(response.data)
			{
				$route.reload();
			}
			else
			{
				alert("errore")
			}

	    });
	}

	// cancella API
//	$scope.deleteAPI = function(IdMS) {
	function deleteAPI(IdMS){
		$http.post("http://localhost:8121/delete_ms?Id=" + IdMS).then(function(response) {
			if(response.data)
			{
				$route.reload();
			}
			else
			{
				alert("errore")
			}

	    });
	}


	$scope.showConfirm = function(ev, IdMS, IsActive) {
		var messaggio = "";
		if(IsActive == 1)
			messaggio = "L'API risulta attiva. Vuoi confermare l'eliminazione?";
		else
			messaggio = "Vuoi confermare l'eliminazione?";
		// Appending dialog to document.body to cover sidenav in docs app
		var confirm = $mdDialog.confirm()
		.title('Eliminazione microservizio')
		.textContent(messaggio)
		.ariaLabel('Lucky day')
		.targetEvent(ev)
		.ok('Elimina')
		.cancel('Annulla');
		$mdDialog.show(confirm).then(function() {
			deleteAPI(IdMS);
		}, function() {
		});
	};

 
});