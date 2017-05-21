'use strict';

angular.module('APIM.lista_api')

.controller('lista_api_ctrl', function($scope, $http, $routeParams) {
	
	$scope.orderName = "Name";

	// inizializzo lista servizi home
	$scope.services = [];
	$scope.anagraphics = [];
	
	// recupera la lista di tutti microservizi con le informazioni da visualizzare nell'elenco
	$http.post("http://localhost:8121/homepage_ms_list").then(function(response) {
		for(var i=0; i < response.data.services.length; i++) {
			$scope.services.push({
				Display: true,
				Name: response.data.services[i].Name,
				Logo: response.data.services[i].Logo,
				IdMS: response.data.services[i].IdMS,
				Developer: response.data.services[i].IdDeveloper,
				categories: response.data.services[i].categories
			});
		}
    }).then(function(response) {
		for(var i=0; i<$scope.services.length; i++) {
			// recupera le anagrafiche del developer a partire dall'id
			$http.post("http://localhost:8101/retrieve_client_anagraphics?Id="+$scope.services[i].Developer).then(function(response) {
				$scope.anagraphics[response.data.IdUser] = response.data.Name + " " + response.data.Surname;
			});
		}
	});
	
	
	// inizializza lista categorie
	$scope.categories = [];

	// recupera la lista di categorie della API del menù di ricerca
	$http.post("http://localhost:8121/retrieve_category_list").then(function(response) {
		$scope.categories.splice(0);
		for(var i=0; i < response.data.categories.length; i++) {
			$scope.categories.push({
				IdCategory: response.data.categories[i].IdCategory, 
				Image: response.data.categories[i].Image, 
				Name: response.data.categories[i].Name
			});
		}
	});
	
	// funzione per filtrare tutte le categorie
	$scope.FilterAll = function() {
		for(var i=0; i<$scope.services.length; i++) {
			$scope.services[i].Display = true;
		}
	};

	// funzione per filtrare per categorie
	$scope.FilterCategory = function(event) { 
		// scorri i servizi nella lista
		for(var i=0; i<$scope.services.length; i++) {
			var trovato = false;
			//scorri le categorie di ogni servizio
			for(var j=0; j<$scope.services[i].categories.length && !trovato; j++) {
				//se trovi categoria allora mostra quel servizio
				if($scope.services[i].categories[j].IdCategory == event.target.attributes.IdCategory.value) {
					$scope.services[i].Display = true;
					trovato = true;
				}
			} 
			// se non la trovi nascondi il servizio
			if(!trovato) {
				$scope.services[i].Display = false;
			}
		}
    };
	
	// funzione per ordinare alfabeticamente
	$scope.OrderByName = function() {
		if($scope.orderName == "Name") {
			$scope.orderName = "-Name";
		}
		else {
			$scope.orderName = "Name";
		}
	};

});