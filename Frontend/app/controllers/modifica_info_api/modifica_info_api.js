'use strict';

angular.module('APIM.modifica_info_api')

.controller('modifica_info_api_ctrl', function($scope, $http, $routeParams) {
	
	$scope.apicurr = $routeParams.api_id;
	$scope.IdMS = Number($scope.apicurr);
	
	// inizializza la lista delle categorie attuali dell'API
	$scope.actualcategories = [];
	
	$http.post("http://localhost:8121/retrieve_categories_of_ms?Id="+$scope.IdMS).then(function(response) {
		for(var i=0; i<response.data.categorydatalist.length; i++) {
			$scope.actualcategories.push({
				IdCategory: response.data.categorydatalist[i].IdCategory
			});
		}		
	});
			
	// inizializza lista categorie apim
	$scope.categories = [];

	// prende dinamicamente la lista di categorie api
	$http.post("http://localhost:8121/retrieve_category_list").then(function(response) {
		var catclass = "label label-default";
		for(var i=0; i<response.data.categories.length; i++) {
			catclass = "label label-default";
			for(var j=0; j<$scope.actualcategories.length; j++) {
				if( $scope.actualcategories[j].IdCategory == response.data.categories[i].IdCategory ) {
					catclass = "label label-success";
				}
			};
			$scope.categories.push({
				IdCategory: response.data.categories[i].IdCategory, 
                Image: response.data.categories[i].Image, 
                Name: response.data.categories[i].Name,
                Class: catclass
            });
		}
	});

        
    $http.get("http://localhost:8121/retrieve_ms_info?Id="+$routeParams.api_id).then(function(response) {
       	$scope.nomeapi = response.data.Name;
	    $scope.descrizione = response.data.Description;
	    $scope.logo_uri = response.data.Logo;
	    $scope.pdf_uri = response.data.DocPDF;
	    $scope.docexternal = response.data.DocExternal;
	    $scope.guadagno = response.data.Profit;
		$scope.slaguaranteed = response.data.SLAGuaranteed;
		$scope.versione = response.data.Version;
		$scope.policy = response.data.Policy;
		$scope.IsActive = response.data.IsActive;
	});
	
	// aggiunge o toglie una categoria all'API  
	$scope.addNewCategory = function(event) {
		if(event.target.attributes.Class.value == "label label-success") {
			$scope.categories[Number(event.target.attributes.IdCategory.value)-1].Class = "label label-default";
		}
		else {
			$scope.categories[Number(event.target.attributes.IdCategory.value)-1].Class = "label label-success";
		}
	};
	
	// aggiorna le categorie dell'API
	$scope.updateCategories = function() {
		for(var i=0; i<$scope.categories.length; i++) {
			var found = false;
			if($scope.categories[i].Class == "label label-success") {
				for(var j=0; j<$scope.actualcategories.length && !found; j++) {
					if($scope.categories[i].IdCategory == $scope.actualcategories[j].IdCategory) {
						found = true;
					}
				}
				if(!found) {
					$http.post("http://localhost:8121/add_category_to_ms?IdMS="+$scope.IdMS+"&IdCategory="+$scope.categories[i].IdCategory);
				}
			}
			else {
				for(var j=0; j<$scope.actualcategories.length && !found; j++) {
					if($scope.categories[i].IdCategory == $scope.actualcategories[j].IdCategory) {
						found = true;
					}
				}
				if(found) {
					$http.post("http://localhost:8121/remove_category_from_ms?IdMS="+$scope.IdMS+"&IdCategory="+$scope.categories[i].IdCategory);
				}
			}
		}
		window.location.reload();
	};
	
	// funzione che invia pdf a filehandler Jolie subito dopo che l'immagine è stata caricata
	$scope.uploadpdf = function(element) {
		var reader = new FileReader();

		reader.onload = function(event) {
			// ricava l'estensione
			var extension = element.files[0].name.split('.').pop();
			// chiamata http al servizio Jolie filehandler.ol
			$http({
				method  : 'POST',
				url     : 'http://localhost:8004/setFile?'+'extension='+extension, // location+operation Jolie
				// inserisce l'immagine secondo la pratica http post piu' efficiente
				transformRequest: function (data) {
					var formData = new FormData();
					formData.append("file", element.files[0]);  // file è il nome del sottotipo che Jolie si aspetta
					return formData;  
				},  
				// per i file inviati tramite form il Content-Type viene messo undefined
				headers: { 'Content-Type': undefined }
			}).then(function(response){
				// ritorna l'uri del file ottenuto dalla response di Jolie
				$scope.pdf_uri = 'http://localhost:8000/resources/api_pdf/'+response.data.$;
			});
		}
		// legge l'immagine come URL
		reader.readAsDataURL(element.files[0]);
	};

	// funzione che invia immagini/file a filehandler Jolie subito dopo che l'immagine è stata caricata
	$scope.uploadlogo = function(element) {
		var reader = new FileReader();
		reader.onload = function(event) {
			// mette il path dell'immagine scelta nell'href dell'avatar
			$scope.logo_presentation = event.target.result
			// ricava l'estensione
			var extension = element.files[0].name.split('.').pop();
			// chiamata http al servizio Jolie filehandler.ol
			$http({
				method  : 'POST',
				url     : 'http://localhost:8004/setFile?'+'extension='+extension, // location+operation Jolie
				// inserisce l'immagine secondo la pratica http post più efficiente
				transformRequest: function (data) {
					var formData = new FormData();
					formData.append("file", element.files[0]);  // file è il nome del sottotipo che Jolie si aspetta
					return formData;  
				},  
				// per i file inviati tramite form il Content-Type va messo undefined
				headers: { 'Content-Type': undefined }
			}).then(function(response){
				// ritorna l'uri del file ottenuto dalla response di Jolie
				$scope.logo_uri = 'http://localhost:8000/resources/uploaded_images/'+response.data.$;
			});
		}
		// legge l'immagine come URL
		reader.readAsDataURL(element.files[0]);
	};
	
	// recupera i crediti ed il tipo dell'utente
	$http.post("http://localhost:8101/retrieve_client_info?Id="+localStorage.getItem("IdClient")).then(function(response) {
		$scope.Credits = response.data.Credits;
		
		if(response.data.ClientType == 1) {
			$scope.ClientType = "Basic";
		}
		else if(response.data.ClientType == 2) {
			$scope.ClientType = "Developer";
		}
		else {
			$scope.ClientType = "Error";
		}
	});
	
	// submit servizio
	$scope.submit = function() {
		
		// aggiorna versione
		$scope.Version = $scope.versione + 1;
		
		// calcola data oggi
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1;
		var yyyy = today.getFullYear();
		if(dd<10) {
			dd='0'+dd;
		};
		if(mm<10) {
			mm='0'+mm;
		};
		$scope.LastUpdate = dd+'/'+mm+'/'+yyyy;
		
		$http.post("http://localhost:8121/microservice_update?" +
			"IdMS=" + $scope.IdMS +
			"&Name=" + $scope.nomeapi +
			"&Description=" + $scope.descrizione +
			"&Version=" + $scope.Version +
			"&LastUpdate=" + $scope.LastUpdate +
			"&Logo=" + $scope.logo_uri +
			"&DocPDF=" + $scope.pdf_uri +
			"&DocExternal=" + $scope.docexternal +
			"&Profit=" + $scope.guadagno +
			"&SLAGuaranteed=" + $scope.slaguaranteed
		).then(function(response) {
			window.location.reload();
		});
		
	};
	
	// controlla se l'utente sia il developer dell'API
	$scope.isDeveloper = function () {
		if(localStorage.getItem("IdClient") == $scope.IdDeveloper) {
			return true;
		}
		else {
			return false;
		}
	};

	// cambia valore isactive
	$scope.changeIsActive = function() {
		var newavailability;
		if( $scope.IsActive ) {
			newavailability = false;
		}
		else {
			newavailability = true;
		}
		$http.post("http://localhost:8121/change_isactive?" +
			"IdMS=" + $scope.IdMS +
			"&IsActive=" + newavailability)
		.then(function(response) {
			window.location.reload();
		});
	};

   
});


