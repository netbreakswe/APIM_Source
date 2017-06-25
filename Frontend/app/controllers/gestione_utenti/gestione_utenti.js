'use strict';

angular.module('APIM.gestione_utenti')

.controller('gestione_utenti_ctrl', function($scope, $http, $mdDialog, $route) {
	
	if(localStorage.getItem("Session") != 'Admin') {
		$location.path("!#");
	};

	$scope.users = [];

	var num_ms = new Array();
	var num_active_ms = new Array();


	// recupera la lista di tutti gli utenti con le informazioni da visualizzare nell'elenco
	$http.post("http://localhost:8101/retrieve_all_client_info").then(function(response) {
		for(var i=0; i < response.data.users.length; i++) {

			$scope.users.push({
				Display: true,
				IdClient: response.data.users[i].IdClient,
				Name: response.data.users[i].Name,
				Surname: response.data.users[i].Surname,
				ClientType: response.data.users[i].ClientType
			});

		}
		

		angular.forEach($scope.users, function(value, key){
			$http.post("http://localhost:8121/retrieve_active_msnumber_from_devid?Id=" + value.IdClient).then(function(response) {
				value.Active_Ms_Number = response.data.$;
			});
		});

		angular.forEach($scope.users, function(value, key){
			$http.post("http://localhost:8121/retrieve_msnumber_from_devid?Id=" + value.IdClient).then(function(response) {
				value.Ms_Number = response.data.$;
			});			
		});

		//console.log($scope.users);
    });


    $scope.showConfirm = function(ev, IdClient, numActive) {

		var messaggio = "";
		var alert;
		console.log("1");

		if(numActive > 0){
			messaggio = "L'utente ha registrato API che risultano ancora attive. Provvedere alla loro disattivazione ed eliminazione prima di procedere con la cancellazione dell'utente.";
			console.log("2");
		    // Internal method
		    var alert  = $mdDialog.alert({
		        title: 'Attenzione',
		        textContent: messaggio,
		        ok: 'Chiudi'
		      });

		      $mdDialog
		        .show( alert )
		        .finally(function() {
		          alert = undefined;
		        });

		}
		else{
			messaggio = "Vuoi confermare l'eliminazione?";
			console.log("3");
			// Appending dialog to document.body to cover sidenav in docs app
			var confirm = $mdDialog.confirm()
			.title('Eliminazione utente')
			.textContent(messaggio)
			.ariaLabel('Lucky day')
			.targetEvent(ev)
			.ok('Elimina')
			.cancel('Annulla');
			$mdDialog.show(confirm).then(function() {
				$http.post("http://localhost:8101/client_delete?IdClient=" + IdClient +
					"&IdAdmin=" + localStorage.getItem("IdAdmin") +
					"&ModType=" + 4 +
					"&Report=" + "Sospettato di traffici illegali"
				);	

				$route.reload();

			}, function() {
			});
		}
		
	};
 
});