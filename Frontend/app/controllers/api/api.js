'use strict';

angular.module('APIM.api')

.controller('api_ctrl', function($scope, $http, $routeParams) {

	$http.post("http://localhost:8121/retrieve_ms_info?Id="+$routeParams.api_id
		).then(function(response) {
			    $scope.IdMS = $routeParams.api_id;
            	$scope.Name = response.data.Name;
            	$scope.Description = response.data.Description;
            	$scope.Version = response.data.Version;
            	$scope.LastUpdate = response.data.LastUpdate;
            	$scope.IdDeveloper = response.data.IdDeveloper;
            	$scope.Logo = response.data.Logo;
            	$scope.DocPDF = response.data.DocPDF;
            	$scope.DocExternal = response.data.DocExternal;
            	$scope.Profit = response.data.Profit;
            	$scope.IsActive = response.data.IsActive;
            	$scope.SLAGuaranteed = response.data.SLAGuaranteed;
            	$scope.Policy = response.data.Policy;

    });


	$http.post("http://localhost:8121/retrieve_client_interface_by_id?Id="+$routeParams.api_id
            ).then(function(response) {
            	$scope.operations = response.data.operations;
            	$scope.types = response.data.types;
            	$scope.client_Interface = response.data.client_Interface;
            	console.log($scope.client_Interface );
             
           });



     $scope.Download_Client_Interface = function () {

		  var blob = new Blob([$scope.client_Interface], {type: 'text/json'});

		  if (window.navigator && window.navigator.msSaveOrOpenBlob) {
		      window.navigator.msSaveOrOpenBlob(blob, $scope.Name + "_" + $scope.IdMS + ".iol");
		  }
		  else{
		      var e = document.createEvent('MouseEvents'),
		          a = document.createElement('a');

		      a.download =  $scope.Name + "_" + $scope.IdMS + ".iol";
		      a.href = window.URL.createObjectURL(blob);
		      a.dataset.downloadurl = ['text/json', a.download, a.href].join(':');
		      e.initEvent('click', true, false, window,
		          0, 0, 0, 0, 0, false, false, false, false, 0, null);
		      a.dispatchEvent(e);
  		}
	};


 
});