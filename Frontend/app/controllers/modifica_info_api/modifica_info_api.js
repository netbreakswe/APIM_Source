'use strict';

angular.module('APIM.modifica_info_api')

.controller('modifica_info_api_ctrl', function($scope, $http, $routeParams) {
	
	$scope.apicurr = $routeParams.api_id;
	  
	// inizializza lista categorie apim
	$scope.categories = [{
		IdCategory: "", 
        Image: "", 
        Name: "",
        Class: ""
	}];

	// prende dinamicamente la lista di categorie api
	$http.post("http://localhost:8121/retrieve_category_list").then(function(response) {
		for(var i=0; i<response.data.categories.length; i++) {
			$scope.categories.push({
				IdCategory: response.data.categories[i].IdCategory, 
                Image: response.data.categories[i].Image, 
                Name: response.data.categories[i].Name,
                Class: "label label-default"
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
	});
	
	// lista categorie selezionate
	$scope.selected_cat = [];
	
	// aggiunge o toglie una categoria al servizio  
	$scope.addNewCategory = function(event) {
		var ok = false;
		// controlla se la categoria sia stata già selezionata
		for(var i=0; i<$scope.selected_cat.length && !ok; i++) {
			// se selezionata, la rimuove dalle categorie selezionate
			if($scope.selected_cat[i] == event.target.attributes.IdCategory.value) {
				$scope.selected_cat.splice(i,1); // rimuove elemento in indice i
				// la deseziona dalla view
				ok = true;
				for(i=0; i<$scope.categories.length; i++) {
					if(event.target.attributes.IdCategory.value == $scope.categories[i].IdCategory) {
						$scope.categories[i].Class = "label label-default";
					}
				}
			} 
		}
		// se non selezionata, la inserisce nell'array delle categorie selezionate
		if(!ok) {
			$scope.selected_cat.push(event.target.attributes.IdCategory.value);
			// applica la class alla categoria
			for(i=0; i<$scope.categories.length; i++) {
				if(event.target.attributes.IdCategory.value == $scope.categories[i].IdCategory) {
					$scope.categories[i].Class = "label label-success";
				}
			}
		}
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
				$scope.pdf_uri = 'http://localhost:8000/images/uploaded_images/'+response.data.$;
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
				$scope.logo_uri = 'http://localhost:8000/images/uploaded_images/'+response.data.$;
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
		
		$scope.Version = $scope.versione + 1;
		$scope.LastUpdate = Date.now();
		$scope.IdMS = Number($scope.apicurr);
		
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
   
});


