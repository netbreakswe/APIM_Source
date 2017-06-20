'use strict';

angular.module('APIM.registra_utente')

.controller('registra_utente_ctrl', function($scope, $http, $window, $location) {
	
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
    "Yemen","Zambia", "Zimbabwe"];

  // funzione per validare le email con regex
  function validateEmail(email) {
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
  };

  // funzione per validare la password
  function checkPassword(str) {
    // almeno un numero, un minuscolo, un maiuscolo, almeno 6 char
    var re = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/;
    return re.test(str);
  };

  var MD5 = function(s){function L(k,d){return(k<<d)|(k>>>(32-d))}function K(G,k){var I,d,F,H,x;F=(G&2147483648);H=(k&2147483648);I=(G&1073741824);d=(k&1073741824);x=(G&1073741823)+(k&1073741823);if(I&d){return(x^2147483648^F^H)}if(I|d){if(x&1073741824){return(x^3221225472^F^H)}else{return(x^1073741824^F^H)}}else{return(x^F^H)}}function r(d,F,k){return(d&F)|((~d)&k)}function q(d,F,k){return(d&k)|(F&(~k))}function p(d,F,k){return(d^F^k)}function n(d,F,k){return(F^(d|(~k)))}function u(G,F,aa,Z,k,H,I){G=K(G,K(K(r(F,aa,Z),k),I));return K(L(G,H),F)}function f(G,F,aa,Z,k,H,I){G=K(G,K(K(q(F,aa,Z),k),I));return K(L(G,H),F)}function D(G,F,aa,Z,k,H,I){G=K(G,K(K(p(F,aa,Z),k),I));return K(L(G,H),F)}function t(G,F,aa,Z,k,H,I){G=K(G,K(K(n(F,aa,Z),k),I));return K(L(G,H),F)}function e(G){var Z;var F=G.length;var x=F+8;var k=(x-(x%64))/64;var I=(k+1)*16;var aa=Array(I-1);var d=0;var H=0;while(H<F){Z=(H-(H%4))/4;d=(H%4)*8;aa[Z]=(aa[Z]| (G.charCodeAt(H)<<d));H++}Z=(H-(H%4))/4;d=(H%4)*8;aa[Z]=aa[Z]|(128<<d);aa[I-2]=F<<3;aa[I-1]=F>>>29;return aa}function B(x){var k="",F="",G,d;for(d=0;d<=3;d++){G=(x>>>(d*8))&255;F="0"+G.toString(16);k=k+F.substr(F.length-2,2)}return k}function J(k){k=k.replace(/rn/g,"n");var d="";for(var F=0;F<k.length;F++){var x=k.charCodeAt(F);if(x<128){d+=String.fromCharCode(x)}else{if((x>127)&&(x<2048)){d+=String.fromCharCode((x>>6)|192);d+=String.fromCharCode((x&63)|128)}else{d+=String.fromCharCode((x>>12)|224);d+=String.fromCharCode(((x>>6)&63)|128);d+=String.fromCharCode((x&63)|128)}}}return d}var C=Array();var P,h,E,v,g,Y,X,W,V;var S=7,Q=12,N=17,M=22;var A=5,z=9,y=14,w=20;var o=4,m=11,l=16,j=23;var U=6,T=10,R=15,O=21;s=J(s);C=e(s);Y=1732584193;X=4023233417;W=2562383102;V=271733878;for(P=0;P<C.length;P+=16){h=Y;E=X;v=W;g=V;Y=u(Y,X,W,V,C[P+0],S,3614090360);V=u(V,Y,X,W,C[P+1],Q,3905402710);W=u(W,V,Y,X,C[P+2],N,606105819);X=u(X,W,V,Y,C[P+3],M,3250441966);Y=u(Y,X,W,V,C[P+4],S,4118548399);V=u(V,Y,X,W,C[P+5],Q,1200080426);W=u(W,V,Y,X,C[P+6],N,2821735955);X=u(X,W,V,Y,C[P+7],M,4249261313);Y=u(Y,X,W,V,C[P+8],S,1770035416);V=u(V,Y,X,W,C[P+9],Q,2336552879);W=u(W,V,Y,X,C[P+10],N,4294925233);X=u(X,W,V,Y,C[P+11],M,2304563134);Y=u(Y,X,W,V,C[P+12],S,1804603682);V=u(V,Y,X,W,C[P+13],Q,4254626195);W=u(W,V,Y,X,C[P+14],N,2792965006);X=u(X,W,V,Y,C[P+15],M,1236535329);Y=f(Y,X,W,V,C[P+1],A,4129170786);V=f(V,Y,X,W,C[P+6],z,3225465664);W=f(W,V,Y,X,C[P+11],y,643717713);X=f(X,W,V,Y,C[P+0],w,3921069994);Y=f(Y,X,W,V,C[P+5],A,3593408605);V=f(V,Y,X,W,C[P+10],z,38016083);W=f(W,V,Y,X,C[P+15],y,3634488961);X=f(X,W,V,Y,C[P+4],w,3889429448);Y=f(Y,X,W,V,C[P+9],A,568446438);V=f(V,Y,X,W,C[P+14],z,3275163606);W=f(W,V,Y,X,C[P+3],y,4107603335);X=f(X,W,V,Y,C[P+8],w,1163531501);Y=f(Y,X,W,V,C[P+13],A,2850285829);V=f(V,Y,X,W,C[P+2],z,4243563512);W=f(W,V,Y,X,C[P+7],y,1735328473);X=f(X,W,V,Y,C[P+12],w,2368359562);Y=D(Y,X,W,V,C[P+5],o,4294588738);V=D(V,Y,X,W,C[P+8],m,2272392833);W=D(W,V,Y,X,C[P+11],l,1839030562);X=D(X,W,V,Y,C[P+14],j,4259657740);Y=D(Y,X,W,V,C[P+1],o,2763975236);V=D(V,Y,X,W,C[P+4],m,1272893353);W=D(W,V,Y,X,C[P+7],l,4139469664);X=D(X,W,V,Y,C[P+10],j,3200236656);Y=D(Y,X,W,V,C[P+13],o,681279174);V=D(V,Y,X,W,C[P+0],m,3936430074);W=D(W,V,Y,X,C[P+3],l,3572445317);X=D(X,W,V,Y,C[P+6],j,76029189);Y=D(Y,X,W,V,C[P+9],o,3654602809);V=D(V,Y,X,W,C[P+12],m,3873151461);W=D(W,V,Y,X,C[P+15],l,530742520);X=D(X,W,V,Y,C[P+2],j,3299628645);Y=t(Y,X,W,V,C[P+0],U,4096336452);V=t(V,Y,X,W,C[P+7],T,1126891415);W=t(W,V,Y,X,C[P+14],R,2878612391);X=t(X,W,V,Y,C[P+5],O,4237533241);Y=t(Y,X,W,V,C[P+12],U,1700485571);V=t(V,Y,X,W,C[P+3],T,2399980690);W=t(W,V,Y,X,C[P+10],R,4293915773);X=t(X,W,V,Y,C[P+1],O,2240044497);Y=t(Y,X,W,V,C[P+8],U,1873313359);V=t(V,Y,X,W,C[P+15],T,4264355552);W=t(W,V,Y,X,C[P+6],R,2734768916);X=t(X,W,V,Y,C[P+13],O,1309151649);Y=t(Y,X,W,V,C[P+4],U,4149444226);V=t(V,Y,X,W,C[P+11],T,3174756917);W=t(W,V,Y,X,C[P+2],R,718787259);X=t(X,W,V,Y,C[P+9],O,3951481745);Y=K(Y,h);X=K(X,E);W=K(W,v);V=K(V,g)}var i=B(Y)+B(X)+B(W)+B(V);return i.toLowerCase()};

  $scope.errors = [];
  $scope.ok = true;


  // funzione che invia immagini/file a filehandler Jolie subito dopo che l'immagine viene caricata
  $scope.submitForm = function() {

        // rimuove/inizializza errori dell'interfaccia grafica
        $scope.errors = [];
		$scope.ok = true;
		
        // lunga lista di gestione errori lato client
		
		if( localStorage.getItem("Session") == 'true' ) {
			$scope.errors.push("Sei già loggato. Non puoi registrare un nuovo account.");
			$scope.ok = false;
		}
		else {
			if( $scope.nome == null || $scope.nome == "") {$scope.errors.push("Nome obbligatorio"); $scope.ok = false;}
			if( $scope.cognome == null || $scope.cognome == "" ) {$scope.errors.push("Cognome obbligatorio"); $scope.ok = false;}
			if( $scope.email == null || $scope.email == "" || !validateEmail($scope.email)) {$scope.errors.push("Email non fornita o non valida"); $scope.ok = false;}
			if( $scope.cittadinanza == null ) {$scope.errors.push("Cittadinanza obbligatoria"); $scope.ok = false;}
			if( $scope.password != $scope.repassword || !checkPassword($scope.password)) {$scope.errors.push("Le password non coincidono o non rispettano il formato richiesto"); $scope.ok = false;}
			if( $scope.avataruri == null) {$scope.errors.push("Avatar non caricato con successo o non scelto"); $scope.ok = false;}
		}
        if( !$scope.ok ) {
          $window.scrollTo(0, 0);
        }
        // se non ci sono errori
        if( $scope.ok == true ) {
			// applica hash con formato md5
			var passmd5 = (MD5($scope.password));
		  
			function generateUUID() {
				var d = new Date().getTime();
				if(typeof performance !== 'undefined' && typeof performance.now === 'function') {
					d += performance.now(); // use high-precision timer if available
				}
				
				var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
				var r = (d + Math.random()*16)%16 | 0;
				d = Math.floor(d/16);
				return (c=='x' ? r : (r&0x3|0x8)).toString(16);
				});

				return uuid;
			}

          // è stato scelto questo metodo di inviare i dati, alla fine, a causa di problemi molto gravi di interfacciamento con Jolie, causati da HTTP access control (CORS) che, nonostante gestito lato server, non permetteva comunque lo scambio di dati, poichè vi era un inconsistenza nell'handshake iniziale client/server

          $http.post("http://localhost:8101/basicclient_registration?"
		    +"IdClient="+generateUUID()
            +"&Name="+$scope.nome
            +"&Surname="+$scope.cognome
            +"&Email="+$scope.email
            +"&Password="+passmd5
            +"&Avatar="+$scope.avataruri
            +"&PayPal="+$scope.paypal
            +"&Citizenship="+$scope.cittadinanza
            +"&AboutMe="+$scope.aboutme
            +"&LinkToSelf="+$scope.linksito
            ).then(function(response) {
                // l'utente esiste già?
                if (response.data.$ == false) {
                    $location.path("/conferma_registrazione");   
                } else {
                    $scope.ok = false;
                    $scope.errors.push("Utente con questa mail gia' registrato");
                    $window.scrollTo(0, 0);
                }
           });

        }        
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
				$scope.avataruri = 'http://localhost:8000/resources/uploaded_images/'+response.data.$;
           });
       }
       // legge l'immagine come URL
       reader.readAsDataURL(element.files[0]);
	};

});