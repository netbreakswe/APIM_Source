'use strict';

angular.module('APIM.api')

.controller('api_ctrl', function($scope, $http, $routeParams) {

	// funzione che recupera tutti i dati dell'API
	$http.post("http://localhost:8121/retrieve_ms_info?Id="+$routeParams.api_id).then(function(response) {
		$scope.IdMS = $routeParams.api_id;
        $scope.Name = response.data.Name;
        $scope.Description = response.data.Description;
        $scope.Version = response.data.Version;
        $scope.LastUpdate = response.data.LastUpdate;
        $scope.Logo = response.data.Logo;
        $scope.DocPDF = response.data.DocPDF;
        $scope.DocExternal = response.data.DocExternal;
        $scope.Profit = response.data.Profit;
        $scope.IsActive = response.data.IsActive;
        $scope.SLAGuaranteed = response.data.SLAGuaranteed;
        $scope.Policy = response.data.Policy;
		
		$scope.IdDeveloper = response.data.IdDeveloper;
		$http.post("http://localhost:8101/retrieve_client_anagraphics?Id="+$scope.IdDeveloper).then(function(response) {
			$scope.Developer = response.data.Name + " " + response.data.Surname;
		});
    }).then(function(response) {
		// recupera il numero di licenze attive della API a partire dall'id
		$http.post("http://localhost:8131/retrieve_active_apikey_number_from_msid?Id="+$scope.IdMS).then(function(response) {
			$scope.ActiveLicenses = response.data.Licenses;
		});
	});
	
	// inizializza lista categorie
	$scope.categories = [];
	
	// recupera la lista di categorie della API
	$http.post("http://localhost:8121/retrieve_categories_of_ms?Id="+$routeParams.api_id).then(function(response) {
		for(var i=0; i<response.data.categorydatalist.length; i++) {
			$scope.categories.push({
				IdCategory: response.data.categorydatalist[i].IdCategory,
				Name: response.data.categorydatalist[i].Name,
				Image: response.data.categorydatalist[i].Image
			});
		}
	});
	
	// controlla se l'utente sia loggato
	$scope.getSession = function() {
		if(localStorage.getItem("Session") == 'true') {
			return true;
		}
		else {
			return false;
		}
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
	
	// controlla se l'utente possieda una licenza attiva per l'API
	$http.post("http://localhost:8131/check_apikey_isactive?" +
		"IdClient=" + localStorage.getItem("IdClient") +
		"&IdMS=" + $routeParams.api_id)
	.then(function(response) {
		$scope.hasActiveLicense = response.data.$;
	});

    // scarica i dati dell'interfaccia client del servizio api_id
	$http.post("http://localhost:8121/retrieve_client_interface_from_id?Id="+$routeParams.api_id).then(function(response) {
        $scope.operations = response.data.operations;
        $scope.types = response.data.types;
        $scope.client_Interface = response.data.client_Interface;
    });

    // permette di scaricare l'interfaccia client in formato .iol
    $scope.Download_Client_Interface = function () {
		var blob = new Blob([$scope.client_Interface], {type: 'text/json'});
		
		if(window.navigator && window.navigator.msSaveOrOpenBlob) {
		    window.navigator.msSaveOrOpenBlob(blob, $scope.Name + "_" + $scope.IdMS + ".iol");
		}
		else {
		    var e = document.createEvent('MouseEvents'),
		    a = document.createElement('a');

		    a.download =  $scope.Name + "_" + $scope.IdMS + ".iol";
		    a.href = window.URL.createObjectURL(blob);
		    a.dataset.downloadurl = ['text/json', a.download, a.href].join(':');
		    e.initEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
		    a.dispatchEvent(e);
  		}
	};
	
	document.getElementById("copyButton").addEventListener("click", function() {
		copyToClipboard(document.getElementById("copyTarget"));
	});

	// copia su clipboard
	function copyToClipboard(elem) {
		// create hidden text element, if it doesn't already exist
		var targetId = "_hiddenCopyText_";
		var isInput = elem.tagName === "INPUT" || elem.tagName === "TEXTAREA";
		var origSelectionStart, origSelectionEnd;
		if(isInput) {
			// can just use the original source element for the selection and copy
			target = elem;
			origSelectionStart = elem.selectionStart;
			origSelectionEnd = elem.selectionEnd;
		} 
		else {
			// must use a temporary form element for the selection and copy
			target = document.getElementById(targetId);
			if(!target) {
				var target = document.createElement("textarea");
				target.style.position = "absolute";
				target.style.left = "-9999px";
				target.style.top = "0";
				target.id = targetId;
				document.body.appendChild(target);
			}
			target.textContent = elem.textContent;
		}
		// select the content
		var currentFocus = document.activeElement;
		target.focus();
		target.setSelectionRange(0, target.value.length);
		
		// copy the selection
		var succeed;
		try {
			succeed = document.execCommand("copy");
		} 
		catch(e) {
			succeed = false;
		}
		// restore original focus
		if(currentFocus && typeof currentFocus.focus === "function") {
			currentFocus.focus();
		}
		if(isInput) {
			// restore prior selection
			elem.setSelectionRange(origSelectionStart, origSelectionEnd);
		} 
		else {
			// clear temporary content
			target.textContent = "";
		}
		return succeed;
	}
 
});