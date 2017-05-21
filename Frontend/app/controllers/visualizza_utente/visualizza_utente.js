'use strict';

angular.module('APIM.visualizza_utente')

.controller('visualizza_utente_ctrl', function($scope, $http, $routeParams) {
	
	$http.post("http://localhost:8101/retrieve_client_info?Id="+$routeParams.user_id).then(function(response) {
	
		$scope.IdClient = $routeParams.user_id;
		$scope.Name = response.data.Name;
		$scope.Surname = response.data.Surname;
		$scope.Avatar = response.data.Avatar;
		$scope.Registration = response.data.Registration;
		$scope.AboutMe = response.data.AboutMe;
		$scope.Citizenship = response.data.Citizenship;
		$scope.LinkToSelf = response.data.LinkToSelf;
		
		$http.post("http://localhost:8101/retrieve_clienttype_info?Id="+response.data.ClientType).then(function(response) {
			$scope.ClientType = response.data.Name;
		});
		
	});
	
	$scope.services = [];
	$scope.activelicenses = [];

	// recupera i microservizi registrati dal developer
	$http.post("http://localhost:8121/retrieve_ms_from_developerid?Id="+$routeParams.user_id).then(function(response) {
		for(var i=0; i<response.data.msdevdata.length; i++) {
			
			$scope.services.push({
				IdMS: response.data.msdevdata[i].IdMS,
				Name: response.data.msdevdata[i].Name,
				Logo: response.data.msdevdata[i].Logo,
				IsActive: response.data.msdevdata[i].IsActive
			});
			
		}
	}).then(function(response) {
		for(var i=0; i<$scope.services.length; i++) {
			// recupera il numero di licenze attive della API a partire dall'id
			$http.post("http://localhost:8131/retrieve_active_apikey_number_from_msid?Id="+$scope.services[i].IdMS).then(function(response) {
				$scope.activelicenses[response.data.IdMS] = response.data.Licenses;
			});
		}
	});
	
});