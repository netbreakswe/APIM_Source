'use strict';

angular.module('APIM.admin_api_list')

.controller('admin_api_list_ctrl', function($scope, $http) {

		//Inizializzo tabella
		$('#table').bootstrapTable({
			pagination: true, // Abilito paginazione
			search: true // Abilito ricerca testuale
		});
});