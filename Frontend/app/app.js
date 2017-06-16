'use strict';

// declare modules

// ordine alfabetico
angular.module('APIM.account', []);
angular.module('APIM.acquista_api', []);
angular.module('APIM.api', []);
angular.module('APIM.api_acquistate', []);
angular.module('APIM.api_registrate', []);
angular.module('APIM.categoria', []);
angular.module('APIM.conferma_login', []);
angular.module('APIM.conferma_registrazione', []);
angular.module('APIM.conferma_registrazione_api', []);
angular.module('APIM.conferma_diventa_sviluppatore', []);
angular.module('APIM.diventa_sviluppatore', []);
angular.module('APIM.lista_api', []);
angular.module('APIM.login', []);
angular.module('APIM.logout', []);
angular.module('APIM.modifica_info_api', []);
angular.module('APIM.modifica_interf_api', []);
angular.module('APIM.modifica_interf_cliente', []);
angular.module('APIM.policych', []);
angular.module('APIM.policytp', []);
angular.module('APIM.policytr', []);
angular.module('APIM.recupero_password', []);
angular.module('APIM.registra_api', []);
angular.module('APIM.registra_utente', []);
angular.module('APIM.registro_transazioni', []);
angular.module('APIM.reset_password', []);
angular.module('APIM.ricarica_crediti', []);
angular.module('APIM.visualizza_utente', []);

// ordine alfabetico
angular.module('APIM', [
    'ngRoute',
    'ngCookies',
	'APIM.account',
	'APIM.acquista_api',
	'APIM.api',
	'APIM.api_acquistate',
	'APIM.api_registrate',
	'APIM.categoria',
	'APIM.conferma_login',
	'APIM.conferma_registrazione',
	'APIM.conferma_registrazione_api',
	'APIM.conferma_diventa_sviluppatore',
	'APIM.diventa_sviluppatore',
	'APIM.lista_api',
	'APIM.login',
	'APIM.logout',
	'APIM.modifica_info_api',
	'APIM.modifica_interf_api',
	'APIM.modifica_interf_cliente',
	'APIM.policych',
	'APIM.policytp',
	'APIM.policytr',
	'APIM.recupero_password',
	'APIM.registra_api',
	'APIM.registra_utente',
	'APIM.registro_transazioni',
	'APIM.reset_password',
	'APIM.ricarica_crediti',
	'APIM.version',
	'APIM.visualizza_utente'
])

.controller('auth_ctrl', function ($scope, $http) {
	
	$scope.Name = localStorage.getItem("Name");
	$scope.Surname = localStorage.getItem("Surname");
	$scope.Avatar = localStorage.getItem("Avatar");
	$scope.ClientType = localStorage.getItem("ClientType");
	
	$scope.getSession = function() {
		if(localStorage.getItem("Session") == 'true') {
			return true;
		}
		else {
			return false;
		}
	};

})

.config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
	$locationProvider.hashPrefix('!');

    $routeProvider
	
		.when('/account', {
			controller: 'account_ctrl',
			templateUrl: 'views/account/account.html'
		})
		
		.when('/acquista_api/:api_id', {
			controller: 'acquista_api_ctrl',
			templateUrl: 'views/acquista_api/acquista_api.html'
		})
	
		.when('/api/:api_id', {
			controller: 'api_ctrl',
			templateUrl: 'views/api/api.html'
		})
		
		.when('/api_acquistate', {
			controller: 'api_acquistate_ctrl',
			templateUrl: 'views/api_acquistate/api_acquistate.html'
		})
		
		.when('/api_registrate', {
			controller: 'api_registrate_ctrl',
			templateUrl: 'views/api_registrate/api_registrate.html'
		})
		
		.when('/categoria/:cat_id', {
            controller: 'categoria_ctrl',
            templateUrl: 'views/categoria/categoria.html'
        })
		
		.when('/conferma_login', {
            controller: 'conferma_login_ctrl',
            templateUrl: 'views/conferma_login/conferma_login.html'
        })
		
		.when('/conferma_registrazione', {
            controller: 'conferma_registrazione_ctrl',
            templateUrl: 'views/conferma_registrazione/conferma_registrazione.html'
        })
		
		.when('/conferma_registrazione_api', {
            controller: 'conferma_registrazione_api_ctrl',
            templateUrl: 'views/conferma_registrazione_api/conferma_registrazione_api.html'
        })
		
		.when('/conferma_diventa_sviluppatore', {
            controller: 'conferma_diventa_sviluppatore_ctrl',
            templateUrl: 'views/conferma_diventa_sviluppatore/conferma_diventa_sviluppatore.html'
        })
		
		.when('/diventa_sviluppatore', {
            controller: 'diventa_sviluppatore_ctrl',
            templateUrl: 'views/diventa_sviluppatore/diventa_sviluppatore.html'
        })
		
		.when('/lista_api', {
            controller: 'lista_api_ctrl',
            templateUrl: 'views/lista_api/lista_api.html'
        })
		
		.when('/login', {
            controller: 'login_ctrl',
            templateUrl: 'views/login/login.html'
        })
		
		.when('/logout', {
            controller: 'logout_ctrl',
            templateUrl: 'views/logout/logout.html'
        })
		
		.when('/modifica_info_api/:api_id', {
			controller: 'modifica_info_api_ctrl',
			templateUrl: 'views/modifica_info_api/modifica_info_api.html'
		})
		
		.when('/modifica_interf_api/:api_id', {
			controller: 'modifica_interf_api_ctrl',
			templateUrl: 'views/modifica_interf_api/modifica_interf_api.html'
		})
		
		.when('/modifica_interf_cliente/:api_id', {
			controller: 'modifica_interf_cliente_ctrl',
			templateUrl: 'views/modifica_interf_cliente/modifica_interf_cliente.html'
		})
		
		.when('/policych', {
			controller: 'policych_ctrl',
			templateUrl: 'views/policych/policych.html'
		})
		
		.when('/policytp', {
			controller: 'policytp_ctrl',
			templateUrl: 'views/policytp/policytp.html'
		})
		
		.when('/policytr', {
			controller: 'policytr_ctrl',
			templateUrl: 'views/policytr/policytr.html'
		})
		
		.when('/recupero_password', {
			controller: 'recupero_password_ctrl',
			templateUrl: 'views/recupero_password/recupero_password.html'
		})
		
		.when('/registra_api', {
			controller: 'registra_api_ctrl',
			templateUrl: 'views/registra_api/registra_api.html'
		})
		
		.when('/registra_utente', {
			controller: 'registra_utente_ctrl',
			templateUrl: 'views/registra_utente/registra_utente.html'
		})
		
		.when('/registro_transazioni', {
			controller: 'registro_transazioni_ctrl',
			templateUrl: 'views/registro_transazioni/registro_transazioni.html'
		})
		
		.when('/reset_password', {
			controller: 'reset_password_ctrl',
			templateUrl: 'views/reset_password/reset_password.html'
		})
		
		.when('/ricarica_crediti', {
			controller: 'ricarica_crediti_ctrl',
			templateUrl: 'views/ricarica_crediti/ricarica_crediti.html'
		})
		
		.when('/visualizza_utente/:user_id', {
			controller: 'visualizza_utente_ctrl',
			templateUrl: 'views/visualizza_utente/visualizza_utente.html'
		})


        .otherwise({ redirectTo: '/lista_api' });
	}
]);