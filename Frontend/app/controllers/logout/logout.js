'use strict';

angular.module('APIM.logout')

.controller('logout_ctrl', function ($scope, $location) {
	localStorage.clear();
});