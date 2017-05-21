'use strict';

angular.module('APIM.account')

.controller('account_ctrl', function($scope, $http) {
	
	// lista Paesi del mondo
	$scope.countries = [
		"Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica",
		"Antigua and Barbuda", "Argentina","Armenia", "Aruba", "Australia", "Austria", "Azerbaijan","Bahamas",
		"Bahrain","Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan",
		"Bolivia","Bosnia and Herzegovina","Botswana","Bouvet Island","Brazil","British Indian Ocean Territory",
		"Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde",
		"Cayman Islands","Central African Republic","Chad","Chile","China", "Christmas Island","Cocos Islands",
		"Colombia","Comoros","Congo","Congo, Democratic Republic of the","Cook Islands","Costa Rica","Cote d'Ivoire",
		"Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador",
		"Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Faroe Islands",
		"Fiji","Finland","France","French Guiana","French Polynesia","Gabon","Gambia","Georgia","Germany","Ghana",
		"Gibraltar","Greece","Greenland","Grenada","Guadeloupe","Guam", "Guatemala","Guinea","Guinea-Bissau",
		"Guyana","Haiti","Heard Island and McDonald Islands","Honduras","Hong Kong","Hungary","Iceland",
		"India","Indonesia","Iran","Iraq", "Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jordan",
		"Kazakhstan", "Kenya", "Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia",
		"Libya","Liechtenstein","Lithuania","Luxembourg","Macao","Madagascar","Malawi","Malaysia","Maldives",
		"Mali","Malta","Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Micronesia",
		"Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar","Namibia",
		"Nauru","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua",
		"Niger", "Nigeria","Norfolk Island","North Korea","Norway","Oman","Pakistan","Palau","Palestinian Territory",
		"Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn","Poland","Portugal","Puerto Rico",
		"Qatar","Romania","Russian Federation","Rwanda","Saint Helena","Saint Kitts and Nevis","Saint Lucia",
		"Saint Pierre and Miquelon","Saint Vincent and the Grenadines", "Samoa","San Marino","Sao Tome and Principe",
		"Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands",
		"Somalia","South Africa","South Georgia","South Korea","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen",
		"Swaziland","Sweden","Switzerland","Syrian Arab Republic","Taiwan","Tajikistan","Tanzania","Thailand",
		"The Former Yugoslav Republic of Macedonia","Timor-Leste","Togo","Tokelau", "Tonga","Trinidad and Tobago",
		"Tunisia","Turkey","Turkmenistan","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom",
		"United States","United States Minor Outlying Islands","Uruguay","Uzbekistan","Vanuatu","Vatican City",
		"Venezuela","Vietnam","Virgin Islands, British","Virgin Islands, U.S.","Wallis and Futuna","Western Sahara",
		"Yemen","Zambia", "Zimbabwe"
	];

	// recupera le informazioni dell'utente, compresi i crediti ed il tipo
	$http.post("http://localhost:8101/retrieve_client_info?Id="+localStorage.getItem("IdClient")).then(function(response) {
		$scope.IdClient = response.data.IdClient;
		$scope.Name = response.data.Name;
		$scope.Surname = response.data.Surname;
		$scope.Email = response.data.Email;
		$scope.Avatar = response.data.Avatar;
		$scope.Registration = response.data.Registration;
		$scope.Credits = response.data.Credits;
		$scope.AboutMe = response.data.AboutMe;
		$scope.Citizenship = response.data.Citizenship;
		$scope.LinkToSelf = response.data.LinkToSelf;
		$scope.PayPal = response.data.PayPal;
		
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
		
	// aggiorna il profilo utente
	$scope.updateProfile = function() {
		$http.post("http://localhost:8101/client_update?" +
			"IdClient=" + localStorage.getItem("IdClient") +
			"&Name=" + $scope.Name +
			"&Surname=" + $scope.Surname +
			"&Email=" + $scope.Email +
			"&Avatar=" + $scope.Avatar +
			"&AboutMe=" + $scope.AboutMe +
			"&Citizenship=" + $scope.Citizenship +
			"&LinkToSelf=" + $scope.LinkToSelf +
			"&PayPal=" + $scope.PayPal
		).then(function(response) {
			
			localStorage.setItem("Name", $scope.Name);
			localStorage.setItem("Surname", $scope.Surname);
			localStorage.setItem("Avatar", $scope.Avatar);
			
			window.location.reload();
			
		});
		
	};
	
	// funzione che invia immagini/file a filehandler Jolie subito dopo che l'immagine viene caricata
    $scope.uploadavatar = function(element) {
		var reader = new FileReader();

		reader.onload = function(event) {
			// mette il path immagine scelta nell'href dell'avatar
			$scope.image_presentation = event.target.result
			// ricava estensione
			var extension = element.files[0].name.split('.').pop();
			// chiamata http al servizio Jolie filehandler.ol
			var uri = $http({
				method  : 'POST',
				url     : 'http://localhost:8004/setFile?'+'extension='+extension, 
				// location + operation Jolie
				// inserisce l'immagine secondo pratica http post più efficiente
				transformRequest: function (data) {
					var formData = new FormData();
					formData.append("file", element.files[0]);  // file nome del sottotipo che Jolie si aspetta
					return formData;  
				},
				// per i file inviati tramite form il Content-Type va messo undefined
				headers: { 'Content-Type': undefined }
			}).then(function(response){
				// ritorna l'uri del file ottenuto dalla response di Jolie
				$scope.Avatar = 'http://localhost:8000/images/avatar utenti/'+response.data.$;
           });
       }
       // legge l'immagine come URL
       reader.readAsDataURL(element.files[0]);
	};
	
	
});