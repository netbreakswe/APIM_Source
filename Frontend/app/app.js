'use strict';

// declare modules

angular.module('APIM.account', []);
angular.module('APIM.api', []);
angular.module('APIM.api_acquistate', []);
angular.module('APIM.api_registrate', []);
angular.module('APIM.conferma_login', []);
angular.module('APIM.conto', []);
angular.module('APIM.lista_api', []);
angular.module('APIM.lista_transazioni', []);
angular.module('APIM.login', []);
angular.module('APIM.logout', []);
angular.module('APIM.policych', []);
angular.module('APIM.policytp', []);
angular.module('APIM.policytr', []);
angular.module('APIM.recupero_password', []);
angular.module('APIM.registra_api', []);
angular.module('APIM.registra_utente', []);
angular.module('APIM.reset_password', []);
angular.module('APIM.modifica_interf_cliente', []);
angular.module('APIM.modifica_info_api', []);
angular.module('APIM.modifica_interf_api', []);



angular.module('APIM', [
    'ngRoute',
    'ngCookies',
	'APIM.account',
	'APIM.api',
	'APIM.api_acquistate',
	'APIM.api_registrate',
	'APIM.conferma_login',
	'APIM.conto',
	'APIM.lista_api',
	'APIM.lista_transazioni',
	'APIM.login',
	'APIM.logout',
	'APIM.policych',
	'APIM.policytp',
	'APIM.policytr',
	'APIM.recupero_password',
	'APIM.modifica_interf_cliente',
	'APIM.modifica_info_api',
	'APIM.modifica_interf_api',
	'APIM.registra_api',
	'APIM.registra_utente',
	'APIM.reset_password',
	'APIM.version'
])

.config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
	$locationProvider.hashPrefix('!');

    $routeProvider
	
		.when('/account', {
			controller: 'account_ctrl',
			templateUrl: 'views/account/account.html'
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
		
		.when('/conferma_login', {
            controller: 'conferma_login_ctrl',
            templateUrl: 'views/conferma_login/conferma_login.html'
        })
		
		.when('/conto', {
			controller: 'conto_ctrl',
			templateUrl: 'views/conto/conto.html'
		})

		.when('/modifica_interf_cliente/:api_id', {
			controller: 'modifica_interf_cliente_ctrl',
			templateUrl: 'views/modifica_interf_cliente/modifica_interf_cliente.html'
		})

		.when('/modifica_interf_api/:api_id', {
			controller: 'modifica_interf_api_ctrl',
			templateUrl: 'views/modifica_interf_api/modifica_interf_api.html'
		})

		.when('/modifica_info_api/:api_id', {
			controller: 'modifica_info_api_ctrl',
			templateUrl: 'views/modifica_info_api/modifica_info_api.html'
		})
		
		.when('/lista_api', {
            controller: 'lista_api_ctrl',
            templateUrl: 'views/lista_api/lista_api.html'
        })
		
		.when('/lista_transazioni', {
			controller: 'lista_transazioni_ctrl',
			templateUrl: 'views/lista_transazioni/lista_transazioni.html'
		})
		
		.when('/login', {
            controller: 'login_ctrl',
            templateUrl: 'views/login/login.html'
        })
		
		.when('/logout', {
            controller: 'logout_ctrl',
            templateUrl: 'views/logout/logout.html'
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
		
		.when('/reset_password', {
			controller: 'reset_password_ctrl',
			templateUrl: 'views/reset_password/reset_password.html'
		})


        .otherwise({ redirectTo: '/lista_api' });
	}
])

