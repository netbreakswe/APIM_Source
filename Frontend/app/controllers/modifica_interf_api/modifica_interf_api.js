'use strict';

angular.module('APIM.modifica_interf_api')

.controller('modifica_interf_api_ctrl', function($scope, $http, $routeParams) {
  $scope.apicurr = $routeParams.api_id

  //recupera interfacce associate ai rispettivi subservizi dell' api
  $http.post("http://localhost:8121/retrieve_interfaces_of_ms?Id="+$routeParams.api_id)
    .then(function(response) {
          $scope.subservices = response.data.subservices;
    });

   /*aggiungi subservizio a lista subservizi nel form*/              
  $scope.addNewSubService = function() {
      $scope.subservices.push({
              location: "", 
              protocol: "", 
              interfaces: [""] 
              });
  };

  /*rimuove ultimo subservizio dalla lista subservizi nel form*/              
  $scope.removeSubService = function() {
    var lastIDS = ($scope.subservices.length)-1;
    $scope.subservices.splice(lastIDS);
  };

  /*aggiungi interfaccia a subservizio IDS nel form*/             
  $scope.addNewInterface = function(IDS) {
    $scope.subservices[IDS].interfaces.push("");

  };
    
  /*rimuovi ultima interfaccia del subservizio IDS nel form*/             
  $scope.removeInterface = function(IDS) {
    var lastItem = (($scope.subservices[IDS]).interfaces.length)-1;
    $scope.subservices[IDS].interfaces.splice(lastItem);
  };

  /*non appena carico interfaccia ne legge il contenuto string in subservices[IDS].interfaces[IDI].content*/
  /**********************************************/
  $scope.saveInterface = function(element) {
      $scope.files = [];
      var reader = new FileReader();
      
      reader.onload = function(event) {
         var ss_pos = (element.getAttribute("IDS")); //pos subservice
         var ssi_pos = (element.getAttribute("IDI")); //pos interface in subservice
         $scope.subservices[ss_pos].interfaces[ssi_pos] = event.target.result;
         $scope.$apply();
         element.style.height = (element[0].scrollHeight < 30) ? 30 + "px" : element[0].scrollHeight + "px";
     }
     reader.readAsText(element.files[0]);
  }
  /**********************************************/


  /*non appena carico interfaccia ne legge il contenuto string in subservices[IDS].interfaces[IDI].content*/
  /**********************************************/
  $scope.confermaModifiche = function(element) {
      $scope.files = [];
      var reader = new FileReader();
      
      reader.onload = function(event) {
         var ss_pos = (element.getAttribute("IDS")); //pos subservice
         var ssi_pos = (element.getAttribute("IDI")); //pos interface in subservice
         $scope.subservices[ss_pos].interfaces[ssi_pos] = event.target.result;
         $scope.$apply();
         element.style.height = (element[0].scrollHeight < 30) ? 30 + "px" : element[0].scrollHeight + "px";
     }
     reader.readAsText(element.files[0]);
  }
  /**********************************************/

     

  

   
});