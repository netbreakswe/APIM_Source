'use strict';

angular.module('APIM.lista_api')

.controller('lista_api_ctrl', function($scope, $http, $routeParams) {

	//inizializzo lista servizi home
	$scope.services = [];

  console.log(localStorage.getItem("Name"));

	//recupera lista completa di tutti microservizi con associati i propri developers
	$http.get("http://localhost:8121/homepage_ms_list").then(function(response1) {

		var i = 0;
		for (i = 0; i < response1.data.services.length; i++) {
			$scope.services.push({
						Display: true,
						Name: response1.data.services[i].Name,
						Logo: response1.data.services[i].Logo,
						IdMS: response1.data.services[i].IdMS,
						Developer: "",
						categories : response1.data.services[i].categories
					});
		   }
    });

  //inizializza lista categorie
	$scope.categories = [];

  /*mi prendo dinamicamente la lista di categorie api*/
  $http.post("http://localhost:8121/retrieve_category_info")
  .then(function(response) {
      var i = 0;
      $scope.categories.splice(0);
      for (i = 0; i < response.data.categories.length; i++) {
        $scope.categories.push({
          IdCategory: response.data.categories[i].IdCategory, 
          Image: response.data.categories[i].Image, 
          Name: response.data.categories[i].Name,
          Class: "label label-default"
       });
      }
   });

  //funzione per filtrare per categorie
  $scope.FilterCategory = function(event) {
      var i = 0; 
      //scorri i servizi nella lista
      for (i; i < $scope.services.length; i++) {
        var trovato = false; var j = 0;
        //scorri le categorie di ogni servizio
        for (j; j < $scope.services[i].categories.length && !trovato; j++) {
          //se trovi categoria allora mostra quel servizio
          if ($scope.services[i].categories[j] == event.target.attributes.IdCategory.value) {
            $scope.services[i].Display = true;
            trovato = true;
          }
        } 
        //se non la trovi nascondi il servizio
        if (!trovato) {
          $scope.services[i].Display = false;
        }
      }
    };



});