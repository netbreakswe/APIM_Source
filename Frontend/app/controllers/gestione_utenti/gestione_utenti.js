'use strict';

angular.module('APIM.gestione_utenti')

.controller('gestione_utenti_ctrl', function($scope, $http) {

	$scope.users = [];

	var num_ms = new Array();
	var num_active_ms = new Array();


	// recupera la lista di tutti gli utenti con le informazioni da visualizzare nell'elenco
	$http.post("http://localhost:8101/retrieve_all_dev_info").then(function(response) {
		for(var i=0; i < response.data.users.length; i++) {

			$scope.users.push({
				Display: true,
				IdClient: response.data.users[i].IdClient,
				Name: response.data.users[i].Name,
				Description: response.data.users[i].Surname
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

		console.log($scope.users);
    });
 
});