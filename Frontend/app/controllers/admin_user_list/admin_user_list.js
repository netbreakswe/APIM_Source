'use strict';

angular.module('APIM.admin_user_list')

.controller('admin_user_list_ctrl', function($scope, $http) {

		/* Questo pezzo va configurato con il servizio
		$http.get("http://localhost:8100/homepage_ms_list?" + apiId).then(function(response) {
		$scope.users = response.data;
		});
		*/

		//provvisorio fino a quando non va il servizio
		$scope.users = [
						{ 
							idUtente:1, 
							nome: "Mark",   
							tipologia: "Sviluppatore",
							licenzeAttive: 13,
							apiEsposte: 35
						},
						{ 
							idUtente:2, 
							nome: "Julie",   
							tipologia: "Sviluppatore",
							licenzeAttive: 15,
							apiEsposte: 454
						},
						{ 
							idUtente:3, 
							nome: "Thomas",   
							tipologia: "Cliente",
							licenzeAttive: 4,
							apiEsposte: 0
						}
					];


 		//Inizializzo tabella
		$('#admin_user_list_table').bootstrapTable({
			pagination: true, // Abilito paginazione
			search: true // Abilito ricerca testuale
		});
});