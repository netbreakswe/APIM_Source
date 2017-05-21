'use strict';

angular.module('APIM.registra_api')

.controller('registra_api_ctrl', function($scope, $http) {

  /*inizializzo lista categorie apim*/
  $scope.categories = [{
              IdCategory: "", 
              Image: "", 
              Name: "",
              Class: ""
  }];

  /*mi prendo dinamicamente la lista di categorie api*/
  $http.post("http://localhost:8121/retrieve_category_info")
        .then(function(response) {
              var i = 0;
              $scope.categories.splice(0);
              for (i = 0; i < response.data.categories.length; i++) {
                $scope.categories.push({
                  IdCategory: response.data.categories[i].IdCategory, 
                  Image: response.data.categories[i].Image, 
                  Name: response.data.categories[i].Name,
                  Class: "label label-default"
               });
              }
        });

  /*inizializzo lista subservizi di un api con un solo subservizio*/
  $scope.subservices = [{
              location: "", 
              protocol: "", 
              interfaces: [] 
  }];

  //lista categorie selezionate
  $scope.selected_cat = [];


  /*aggiungi subservizio a lista subservizi nel form. se gia' selezionato rimuovi*/              
  $scope.addNewCategory = function(event) {
     var i = 0; var ok = false;
     //controllo se categoria gia' selezionata
     for (i = 0; i < $scope.selected_cat.length && !ok; i++) {
        //se si rimuovila dalle categorie selezionate
        if ($scope.selected_cat[i] == event.target.attributes.IdCategory.value) {
            $scope.selected_cat.splice(i, 1); //rimuove elemento a indice i
            //desezionala dalla view
            ok = true;
            for (i = 0; i < $scope.categories.length; i++) {
              if (event.target.attributes.IdCategory.value == $scope.categories[i].IdCategory) {
                $scope.categories[i].Class = "label label-default";
              }
            }
        } 
     }
     //se no allora inseriscila nella array delle categorie selezionate
     if (!ok) {
      $scope.selected_cat.push(event.target.attributes.IdCategory.value);
      //tutte le categorie selezionate avranno un look differente (Class) per far capire all'utente
      for (i = 0; i < $scope.categories.length; i++) {
        if (event.target.attributes.IdCategory.value == $scope.categories[i].IdCategory) {
          $scope.categories[i].Class = "label label-success";
        }
      }
    }
  };




  /*aggiungi subservizio a lista subservizi nel form*/              
  $scope.addNewSubService = function() {
      $scope.subservices.push({
              location: "", 
              protocol: "", 
              interfaces: [] 
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

  /*funzione che invia pdf a filehandler Jolie subito dopo che immagine caricata*/
  /**********************************************/
  $scope.uploadpdf = function(element) {

      var reader = new FileReader();

      reader.onload = function(event) {
        //ricava estensione
        var extension = element.files[0].name.split('.').pop();
        /*chiamata http a servizio Jolie filehandler.ol*/
        $http({
            method  : 'POST',
            url     : 'http://localhost:8004/setFile?'+'extension='+extension, //location+operation Jolie
            /*inserisco l'immagine secondo pratica http post piu' efficiente*/
            transformRequest: function (data) {
                var formData = new FormData();
                formData.append("file", element.files[0]);  //'file' nome del sottotipo che Jolie si aspetta
                return formData;  
            },  
            /*per i file inviati tramite form il Content-Type va messo undefined*/
            headers: { 'Content-Type': undefined }
         }).then(function(response){
            /*ritorno uri del file ottenuto dalla response di Jolie*/
            $scope.pdf_uri = 'http://localhost:8004/'+response.data.$;
         });
     }
     //leggo immagine come URL
     reader.readAsDataURL(element.files[0]);
  }
  /**********************************************/

  /*funzione che invia immagini/file a filehandler Jolie subito dopo che immagine caricata*/
  /**********************************************/
  $scope.uploadlogo = function(element) {
      var reader = new FileReader();
      reader.onload = function(event) {
        //metti path immagine scelta nell'href dell'avatar
        $scope.logo_presentation = event.target.result
        //ricava estensione
        var extension = element.files[0].name.split('.').pop();
        /*chiamata http a servizio Jolie filehandler.ol*/
        $http({
            method  : 'POST',
            url     : 'http://localhost:8004/setFile?'+'extension='+extension, //location+operation Jolie
            /*inserisco l'immagine secondo pratica http post piu' efficiente*/
            transformRequest: function (data) {
                var formData = new FormData();
                formData.append("file", element.files[0]);  //'file' nome del sottotipo che Jolie si aspetta
                return formData;  
            },  
            /*per i file inviati tramite form il Content-Type va messo undefined*/
            headers: { 'Content-Type': undefined }
         }).then(function(response){
            /*ritorno uri del file ottenuto dalla response di Jolie*/ 
            $scope.logo_uri = 'http://localhost:8004/'+response.data.$;
         });
     }
     //leggo immagine come URL
     reader.readAsDataURL(element.files[0]);
  }
  /**********************************************/

  //submit servizio
  /**********************************************/
  $scope.submit = function() {
      console.log( $scope.subservices); //testing subservices -> see log

      var data = {
        subservices : $scope.subservices,
        categories: $scope.selected_cat,
        Name: $scope.nomeapi,
        Description: $scope.descrizione,
        IdDeveloper: localStorage.getItem("IdClient"),
        Logo: $scope.logo_uri,
        DocPDF: $scope.pdf_uri,
        DocExternal: $scope.docexternal,
        Profit: $scope.guadagno,
        Policy: $scope.policy
      };


      $http({
            method  : 'POST',
            url     : "http://localhost:8121/microservice_registration",
            transformRequest: function () {
                var formData = new FormData();
                formData.append("data", JSON.stringify(data));  
                return formData;  
            },  
            /*per i file inviati tramite form il Content-Type va messo undefined*/
            headers: { 'Content-Type': undefined }
         }).then(function(response){
            /*ritorno uri del file ottenuto dalla response di Jolie*/ 
         });
    };

    /**********************************************/



});