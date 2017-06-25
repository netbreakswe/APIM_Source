'use strict';

angular.module('APIM.registra_api')

.controller('registra_api_ctrl', function($scope, $http, $window, $location) {
	
	if(localStorage.getItem("Session") != 'true' || localStorage.getItem("ClientType") != 2) {
		$location.path("!#");
	};
	
	// inizializza lista categorie apim
	$scope.categories = [];

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

	// inizializza lista subservizi di un api con un solo subservizio
	$scope.subservices = [{
        location: "", 
        protocol: "sodep", 
        interfaces: [] 
	}];

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
	
	/* Per implementarezione subservizio di APIMarket futura
	
	// aggiunge un subservizio alla lista subservizi nel form    
	$scope.addNewSubService = function() {
		$scope.subservices.push({
            location: "", 
            protocol: "sodep", 
            interfaces: [] 
        });
		// inizializza l'interfaccia del subservizio
		var lastIDS = ($scope.subservices.length)-1;
		$scope.subservices[lastIDS].interfaces.push("");
	};

	// rimuove l'ultimo subservizio dalla lista subservizi nel form       
	$scope.removeSubService = function() {
		var lastIDS = ($scope.subservices.length)-1;
		if( lastIDS > 0 ) {
			// se è un subservizio
			$scope.subservices.splice(lastIDS);
		}
		// se è il servizio principale, non lo rimuove
	};
	
	*/
	
	// inizializza l'interfaccia del servizio
	$scope.subservices[0].interfaces.push("");

	// non appena carica l'interfaccia ne legge il contenuto string in subservices[IDS].interfaces[IDI].content
	$scope.saveInterface = function(element) {
		$scope.files = [];
		var reader = new FileReader();
      
		reader.onload = function(event) {
			var ss_pos = (element.getAttribute("IDS")); // pos subservice
			var ssi_pos = (element.getAttribute("IDI")); // pos interface in subservice
			$scope.subservices[ss_pos].interfaces[ssi_pos] = event.target.result;
			$scope.$apply();
			element.style.height = (element[0].scrollHeight < 30) ? 30 + "px" : element[0].scrollHeight + "px";
			// scrollHeight causa errore su console browser
		}
		reader.readAsText(element.files[0]);
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
	
	$scope.errors = [];
	$scope.ok = true;

	// submit servizio
	$scope.submit = function() {
		
		// rimuove/inizializza errori dell'interfaccia grafica
        $scope.errors = [];
		
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
		
		if( localStorage.getItem("ClientType") != 2 ) {
			$scope.ok = false;
			$scope.errors.push("Non sei uno sviluppatore. Non puoi registrare nuove API.");
			$window.scrollTo(0, 0);
		}
		else if( $scope.subservices[0].location == "" || $scope.subservices[0].protocol == "" || $scope.subservices[0].interfaces == "" || $scope.nomeapi == null || $scope.descrizione == null || $scope.logo_uri == null || $scope.pdf_uri == null || $scope.docexternal == null || $scope.guadagno == null || $scope.slagarantita == null || $scope.policy == null) {
			$scope.ok = false;
			$scope.errors.push("Errore/i nella registrazione dell'API. Attenzione, tutti i campi sono obbligatori.");
			$window.scrollTo(0, 0);
		}
		else {
			var data = {
				subservices : $scope.subservices,
				categories: $scope.selected_cat,
				Name: $scope.nomeapi,
				Description: $scope.descrizione,
				LastUpdate: $scope.LastUpdate,
				IdDeveloper: localStorage.getItem("IdClient"),
				Logo: $scope.logo_uri,
				DocPDF: $scope.pdf_uri,
				DocExternal: $scope.docexternal,
				Profit: $scope.guadagno,
				SLAGuaranteed: $scope.slagarantita,
				Policy: $scope.policy
			};

			$http({
				method  : 'POST',
				url     : "http://localhost:8121/microservice_registration",
				transformRequest: function () {
					var formData = new FormData();
					formData.append("data", JSON.stringify(data));  
					return formData;  
				},  
				// per i file inviati tramite form il Content-Type va messo undefined
				headers: { 'Content-Type': undefined }
			}).then(function(response) {
				$location.path("/conferma_registrazione_api");
			});
		};
		
    };
	

});