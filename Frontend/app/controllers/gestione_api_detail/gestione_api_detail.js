'use strict';

angular.module('APIM.gestione_api_detail')

.controller('gestione_api_detail_ctrl', function($scope, $http, $route, $mdDialog, $routeParams) {


	// funzione che recupera tutti i dati dell'API
	$http.post("http://localhost:8121/retrieve_ms_info?Id="+$routeParams.IdMS).then(function(response) {
		$scope.IdMS = $routeParams.IdMS;
        $scope.Name = response.data.Name;
        $scope.Description = response.data.Description;
        $scope.Version = response.data.Version;
        $scope.LastUpdate = response.data.LastUpdate;
        $scope.Logo = response.data.Logo;
        $scope.DocPDF = response.data.DocPDF;
        $scope.DocExternal = response.data.DocExternal;
        $scope.Profit = response.data.Profit;
        $scope.IsActive = response.data.IsActive;
        $scope.SLAGuaranteed = response.data.SLAGuaranteed;
        $scope.Policy = response.data.Policy;
		
		$scope.IdDeveloper = response.data.IdDeveloper;

		$http.post("http://localhost:8101/retrieve_client_anagraphics?Id="+$scope.IdDeveloper).then(function(response) {
			$scope.Developer = response.data.Name + " " + response.data.Surname;
		});

		console.log("http://localhost:8141/retrieve_average_response_time_from_msid?Id="+$routeParams.IdMS);
		$http.post("http://localhost:8141/retrieve_average_response_time_from_msid?Id="+$routeParams.IdMS).then(function(response) {
			$scope.av_Response_Time = response.data.$;
		});

    }).then(function(response) {
		// recupera il numero di licenze attive della API a partire dall'id
		$http.post("http://localhost:8131/retrieve_active_apikey_number_from_msid?Id="+$scope.IdMS).then(function(response) {
			$scope.ActiveLicenses = response.data.Licenses;
		});
	});

	
	
	// inizializza lista categorie
	$scope.categories = [];
	
	// recupera la lista di categorie della API
	$http.post("http://localhost:8121/retrieve_categories_of_ms?Id="+$routeParams.IdMS).then(function(response) {
		for(var i=0; i<response.data.categorydatalist.length; i++) {
			$scope.categories.push({
				IdCategory: response.data.categorydatalist[i].IdCategory,
				Name: response.data.categorydatalist[i].Name,
				Image: response.data.categorydatalist[i].Image
			});
		}
	});

	//inizializzio lista utenti con licenze attive
	$scope.users = [];

	var usersTMP = new Array(); 

	// recupera la lista di id utente con licenza attiva per l'API
	$http.post("http://localhost:8131/retrieve_active_apikey_userid_from_msid?Id="+$routeParams.IdMS).then(function(response) {
		if(response.data.idlist){
			for(var i=0; i<response.data.idlist.length; i++) {
				var idtmp = response.data.idlist[i].Id;
				usersTMP[i+1] = idtmp;
			}//for
			usersTMP.forEach(function(val){
				$http.post("http://localhost:8101/retrieve_client_anagraphics?Id=" + val).then(function(response) {
					$scope.users.push({
						IdUser: val,
						Name: response.data.Name,
						Surname: response.data.Surname
					});
				});
			});
		}//if
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
		$http.post("http://localhost:8121/deactivate_ms?Id=" + IdMS).then(function(response) {
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
		$http.post("http://localhost:8121/activate_ms?Id=" + IdMS).then(function(response) {
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