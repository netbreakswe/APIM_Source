'use strict';

angular.module('APIM.admin_api_user')

.controller('admin_api_user_ctrl', function($scope, $routeParams, $http) {

	var apiId = $routeParams.apiId;

	/* Questo pezzo va configurato con il servizio
	$http.get("http://localhost:8100/homepage_ms_list?" + apiId).then(function(response) {
        $scope.users = response.data;
    });
	*/

		//provvisorio fino a quando non va il servizio
		$scope.users = [
						{ 
							idUtente:1, 
							idLicenza: "156adx12",
							nome: "Trekker",   
							policy: "A chiamata",
							inizioValidita: "1/2/2017",
							fineValidita: "31/7/2017"
						},
						{ 
							idUtente:2, 
							idLicenza: "dfw1werx12",
							nome: "Marco ",   
							policy: "A chiamata",
							inizioValidita: "1/9/2017",
							fineValidita: "31/12/2017"
						},
						{ 
							idUtente:3, 
							idLicenza: "wfvev564fve",
							nome: "Giovanni",   
							policy: "A chiamata",
							inizioValidita: "1/5/2017",
							fineValidita: "31/12/2017"
						}
					];

  	//Inizializzo tabella
	$('#table_api_user').bootstrapTable({
		pagination: true, // Abilito paginazione
		search: true // Abilito ricerca testuale
	});
		

});