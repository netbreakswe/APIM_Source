'use strict';

angular.module('APIM.modifica_info_api')

.controller('modifica_info_api_ctrl', function($scope, $http, $routeParams) {
	  $scope.apicurr = $routeParams.api_id

        
       $http.get("http://localhost:8121/retrieve_ms_info?Id="+$routeParams.api_id).then(function(response) {
       		$scope.nomeapi = response.data.Name;
	        $scope.descrizione = response.data.Description;
	        $scope.logo_uri = response.data.Logo;
	        $scope.pdf_uri = response.data.DocPDF;
	        $scope.docexternal = response.data.DocExternal;
	        $scope.guadagno = response.data.Profit;
   		});


/*type msupdata: void {
	.IdMS: int
	.Name: string
	.Description: string
	.Version: int
	.LastUpdate: string
	.Logo: string
	.DocPDF: string
	.DocExternal: string
	.Profit: int
	.SLAGuaranteed: double
}*/




   
});


