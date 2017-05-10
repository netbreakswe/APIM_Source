'use strict';

angular.module('APIM.modifica_interf_cliente')

.controller('modifica_interf_cliente_ctrl', function($scope, $http, $routeParams) {
    $scope.apicurr = $routeParams.api_id


    //inzializzo lista operazioni
    $scope.operations = [];

    //recupero le info dell'interfaccia cliente del servizio i
	$http.post("http://localhost:8121/retrieve_client_interface_by_id?Id="+$routeParams.api_id
            ).then(function(response) {
            	var i = 0; 
            	for (i = 0; i < response.data.operations.length; i++) {
			        $scope.operations.push({
			          name: response.data.operations[i].name, 
			          request: response.data.operations[i].request, 
			          response: response.data.operations[i].response,
			          description: response.data.operations[i].description,
			          ecceptions: response.data.operations[i].ecceptions
			       });
			     }
            	$scope.types = response.data.types;
            	$scope.client_Interface = response.data.client_Interface;
            	console.log($scope.client_Interface );
           });



    //invia dati per aggiornare le descrizioni dell' interfaccia cliente
    $scope.confermaModifiche = function() {
      var data = {
        operations : $scope.operations,
        types: $scope.types
      };

      $http({
            method  : 'POST',
            url     : "http://localhost:8121/update_client_interface_by_id?Id="+$routeParams.api_id,
            transformRequest: function () {
                var formData = new FormData();
                formData.append("data", JSON.stringify(data));  
                return formData;  
            },   
            headers: { 'Content-Type': undefined }
         }).then(function(response){
         	//
         });
    };

   
});