'use strict';

angular.module('APIM.ricarica_crediti')

.controller('ricarica_crediti_ctrl', function($scope, $http, $location) {
	
	if(localStorage.getItem("Session") != 'true') {
		$location.path("!#");
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
	
	// pulsante 100
	paypal.Button.render({

		env: 'sandbox', // sandbox | production

		// PayPal Client IDs - replace with your own
		// Create a PayPal app: https://developer.paypal.com/developer/applications/create
		client: {
			sandbox:    'AZDxjDScFpQtjWTOUtWKbyN_bDt4OgqaF4eYXlewfBP4-8aqX3PiV8e1GWU6liB2CUXlkA59kJXE7M6R',
			production: '<insert production client id>'
		},

		// Show the buyer a 'Pay Now' button in the checkout flow
		commit: true,

		// payment() is called when the button is clicked
		payment: function(data, actions) {

			// Make a call to the REST api to create the payment
			return actions.payment.create({
				transactions: [{
					amount: { total: '1', currency: 'EUR' }
				}]
			});
		},

		// onAuthorize() is called when the buyer approves the payment
		onAuthorize: function(data, actions) {
			
			function updateCredits() {
				$http.post("http://localhost:8101/credits_update?IdClient=" + localStorage.getItem("IdClient") + "&Credits=" + 100).then(function(response) {
					window.location.reload();
				});
			};

			// Make a call to the REST api to execute the payment
			return actions.payment.execute().then(function(param) {
				updateCredits();
			});
		}

	}, '#paypal-button-container100');
	
	// pulsante 200
	paypal.Button.render({

		env: 'sandbox', // sandbox | production

		// PayPal Client IDs - replace with your own
		// Create a PayPal app: https://developer.paypal.com/developer/applications/create
		client: {
			sandbox:    'AZDxjDScFpQtjWTOUtWKbyN_bDt4OgqaF4eYXlewfBP4-8aqX3PiV8e1GWU6liB2CUXlkA59kJXE7M6R',
			production: '<insert production client id>'
		},

		// Show the buyer a 'Pay Now' button in the checkout flow
		commit: true,

		// payment() is called when the button is clicked
		payment: function(data, actions) {

			// Make a call to the REST api to create the payment
			return actions.payment.create({
				transactions: [{
					amount: { total: '2', currency: 'EUR' }
				}]
			});
		},

		// onAuthorize() is called when the buyer approves the payment
		onAuthorize: function(data, actions) {
			
			function updateCredits() {
				$http.post("http://localhost:8101/credits_update?IdClient=" + localStorage.getItem("IdClient") + "&Credits=" + 200).then(function(response) {
					window.location.reload();
				});
			};

			// Make a call to the REST api to execute the payment
			return actions.payment.execute().then(function(param) {
				updateCredits();
			});
		}

	}, '#paypal-button-container200');
	
	// pulsante 500
	paypal.Button.render({

		env: 'sandbox', // sandbox | production

		// PayPal Client IDs - replace with your own
		// Create a PayPal app: https://developer.paypal.com/developer/applications/create
		client: {
			sandbox:    'AZDxjDScFpQtjWTOUtWKbyN_bDt4OgqaF4eYXlewfBP4-8aqX3PiV8e1GWU6liB2CUXlkA59kJXE7M6R',
			production: '<insert production client id>'
		},

		// Show the buyer a 'Pay Now' button in the checkout flow
		commit: true,

		// payment() is called when the button is clicked
		payment: function(data, actions) {

			// Make a call to the REST api to create the payment
			return actions.payment.create({
				transactions: [{
					amount: { total: '5', currency: 'EUR' }
				}]
			});
		},

		// onAuthorize() is called when the buyer approves the payment
		onAuthorize: function(data, actions) {
			
			function updateCredits() {
				$http.post("http://localhost:8101/credits_update?IdClient=" + localStorage.getItem("IdClient") + "&Credits=" + 500).then(function(response) {
					window.location.reload();
				});
			};

			// Make a call to the REST api to execute the payment
			return actions.payment.execute().then(function(param) {
				updateCredits();
			});
		}

	}, '#paypal-button-container500');
	
	// pulsante 1000
	paypal.Button.render({

		env: 'sandbox', // sandbox | production

		// PayPal Client IDs - replace with your own
		// Create a PayPal app: https://developer.paypal.com/developer/applications/create
		client: {
			sandbox:    'AZDxjDScFpQtjWTOUtWKbyN_bDt4OgqaF4eYXlewfBP4-8aqX3PiV8e1GWU6liB2CUXlkA59kJXE7M6R',
			production: '<insert production client id>'
		},

		// Show the buyer a 'Pay Now' button in the checkout flow
		commit: true,

		// payment() is called when the button is clicked
		payment: function(data, actions) {

			// Make a call to the REST api to create the payment
			return actions.payment.create({
				transactions: [{
					amount: { total: '9', currency: 'EUR' }
				}]
			});
		},

		// onAuthorize() is called when the buyer approves the payment
		onAuthorize: function(data, actions) {
			
			function updateCredits() {
				$http.post("http://localhost:8101/credits_update?IdClient=" + localStorage.getItem("IdClient") + "&Credits=" + 1000).then(function(response) {
					window.location.reload();
				});
			};

			// Make a call to the REST api to execute the payment
			return actions.payment.execute().then(function(param) {
				updateCredits();
			});
		}

	}, '#paypal-button-container1000');
	
	// pulsante 2000
	paypal.Button.render({

		env: 'sandbox', // sandbox | production

		// PayPal Client IDs - replace with your own
		// Create a PayPal app: https://developer.paypal.com/developer/applications/create
		client: {
			sandbox:    'AZDxjDScFpQtjWTOUtWKbyN_bDt4OgqaF4eYXlewfBP4-8aqX3PiV8e1GWU6liB2CUXlkA59kJXE7M6R',
			production: '<insert production client id>'
		},

		// Show the buyer a 'Pay Now' button in the checkout flow
		commit: true,

		// payment() is called when the button is clicked
		payment: function(data, actions) {

			// Make a call to the REST api to create the payment
			return actions.payment.create({
				transactions: [{
					amount: { total: '17', currency: 'EUR' }
				}]
			});
		},

		// onAuthorize() is called when the buyer approves the payment
		onAuthorize: function(data, actions) {
			
			function updateCredits() {
				$http.post("http://localhost:8101/credits_update?IdClient=" + localStorage.getItem("IdClient") + "&Credits=" + 2000).then(function(response) {
					window.location.reload();
				});
			};

			// Make a call to the REST api to execute the payment
			return actions.payment.execute().then(function(param) {
				updateCredits();
			});
		}

	}, '#paypal-button-container2000');
	
	// pulsante 5000
	paypal.Button.render({

		env: 'sandbox', // sandbox | production

		// PayPal Client IDs - replace with your own
		// Create a PayPal app: https://developer.paypal.com/developer/applications/create
		client: {
			sandbox:    'AZDxjDScFpQtjWTOUtWKbyN_bDt4OgqaF4eYXlewfBP4-8aqX3PiV8e1GWU6liB2CUXlkA59kJXE7M6R',
			production: '<insert production client id>'
		},

		// Show the buyer a 'Pay Now' button in the checkout flow
		commit: true,

		// payment() is called when the button is clicked
		payment: function(data, actions) {

			// Make a call to the REST api to create the payment
			return actions.payment.create({
				transactions: [{
					amount: { total: '41', currency: 'EUR' }
				}]
			});
		},

		// onAuthorize() is called when the buyer approves the payment
		onAuthorize: function(data, actions) {
			
			function updateCredits() {
				$http.post("http://localhost:8101/credits_update?IdClient=" + localStorage.getItem("IdClient") + "&Credits=" + 5000).then(function(response) {
					window.location.reload();
				});
			};

			// Make a call to the REST api to execute the payment
			return actions.payment.execute().then(function(param) {
				updateCredits();
			});
		}

	}, '#paypal-button-container5000');
	
});