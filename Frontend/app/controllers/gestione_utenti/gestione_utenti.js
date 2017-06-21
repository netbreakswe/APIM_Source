'use strict';

angular.module('APIM.gestione_utenti')

.controller('gestione_utenti_ctrl', function($scope, $http) {

	$scope.users = [];

	// recupera la lista di tutti microservizi con le informazioni da visualizzare nell'elenco
	$http.post("http://localhost:8121/retrieve_all_client_info").then(function(response) {
		for(var i=0; i < response.data.alluserdata.length; i++) {
			$scope.users.push({
				Display: true,
				IdMS: response.data.alluserdata[i].IdMS,
				Name: response.data.alluserdata[i].Name,
				Description: response.data.alluserdata[i].Description,
				Version: response.data.alluserdata[i].Version,
				LastUpdate: response.data.alluserdata[i].LastUpdate,
				Developer: response.data.alluserdata[i].IdDeveloper,
				Logo: response.data.alluserdata[i].Logo,
				DocPDF: response.data.alluserdata[i].DocPDF,
				DocExternal: response.data.alluserdata[i].DocExternal,
				Profit: response.data.alluserdata[i].Profit,
				IsActive: response.data.alluserdata[i].IsActive,
				SLAGuaranteed: response.data.alluserdata[i].SLAGuaranteed,
				Policy: response.data.alluserdata[i].Policy
			});
		}
    });
 
});