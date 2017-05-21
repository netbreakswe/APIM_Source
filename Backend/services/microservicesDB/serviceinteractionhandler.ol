include "console.iol"
include "interfaces/serviceinteractionhandlerinterface.iol"

execution { concurrent }

inputPort ServiceInterationHandler {
   Location: "socket://localhost:8322"
   Protocol: http 
   Interfaces: ServiceInteractionHandlerInterface
}

/*1. Procedura che determina se _T e' gia' presente in array _arr*/
define __isInArrayAndPos {
  _trovato = false;
  _pos = 0;
  while(_pos < #_arr && !_trovato) {
      if (_arr[_pos] == _T) {
        _trovato = true
      } else {
        _pos++
      }
  }
}

/*2. manca check su apikey e sla survey (dipendenti da acquisto)*/


init {
  /*lista di tutti i tipi primitivi in Jolie*/
  primitive[ 0 ] = "bool"; primitive[ 1 ] = "int"; primitive[ 2 ] = "long"; primitive[ 3 ] = "double";
  primitive[ 4 ] = "string"; primitive[ 5 ] = "raw"; primitive[ 6 ] = "void"; primitive[7] = "any";
  primitive[ 8 ] = "undefined"
}

main {
  /*1. (da gestire)controllo correttezza interfacce, 
    2. se ci sono tipi con nomi uguale ma implem. diversa  
    3. se ci sono operation con nome uguale ma tipi diversi 
  */
  [getServiceMetaFromCourier( request )( response ) {
      metareq.name.name = "Client"; metareq.name.domain = "gateway"; metareq.filename = request;
      /*ottieni meta dati in formato MetaJolie*/
      getInputPortMetaData@MetaJolie( metareq )( meta );
      /*ricavo tutte le metainformazioni circa servizio APIM*/
      primitiveextention = 0; //numero tipi primitivi distinti nelle request delle operation
      /*scorri tutte le interfacce*/
      for (i = 0, i < #meta.input[0].interfaces, i++) {
          /*scorri i tipi complessi dell'interfaccia i*/
          for ( k = 0, k < #meta.input[0].interfaces[i].types, k++ ) {
             /*controllo se questo tipo complesso gia' incontrato*/
             _T -> meta.input[0].interfaces[i].types[k].name.name;
             _arr -> response.types;
             __isInArrayAndPos;
             /*se tipo con questo nome non incontrato salva in array*/
             if (!_trovato) {
                pos = #response.types;
                response.types[pos] << meta.input[0].interfaces[i].types[k].name.name;
                response.types[pos].name << meta.input[0].interfaces[i].types[k].name.name;
                getType@Parser(meta.input[0].interfaces[i].types[k])(complextype);
                response.types[pos].definition << complextype
             } 
          };
          /*scorri le operation dell'interfaccia i*/
          for ( j = 0, j < #meta.input[0].interfaces[i].operations, j++ ) {
             ops = #response.operations;
             response.operations[ops].name << meta.input[0].interfaces[i].operations[j].operation_name; //nome operation j
             /*tipo della richiesta dell'operation j dell'interfaccia i e' tipo primitivo?*/
             _T -> meta.input[0].interfaces[i].operations[j].input.name;
             _arr -> primitive;
             __isInArrayAndPos;
             /*se si*/
             if (_trovato) {
                /*tipo primitivo gia' incontrato?*/
                _arr -> response.types;
                __isInArrayAndPos;
                /*se tipo non incontrato salva in array response.types*/
                if (!_trovato) {
                   pos = #response.types;
                   response.types[pos] << _T; 
                   response.types[pos].name << "t" + primitiveextention; /*nome esteso*/
                   response.types[pos].definition << "type t"+primitiveextention+": "+response.types[pos]+"{\n .key:string \n}";
                   response.operations[ops].request << response.types[pos].name;
                   primitiveextention++

                /*se tipo gia' incontrato*/
                } else {
                  response.operations[ops].request << response.types[_pos].name
                }
              }
              /*altrimenti salva in operations il nome del tipo complesso del tipo di andata dell'operation j*/
              else {
                response.operations[ops].request << _T
              };
              /*salva in in operations il tipo di ritorno dell'operation j*/
              response.operations[ops].response << meta.input[0].interfaces[i].operations[j].output.name;
              for (m = 0, m < meta.input[0].interfaces[i].operations[j].fault[m], m++) {
                response.operations[ops].ecceptions.name = meta.input[0].interfaces[i].operations[j].fault[m].name;
                response.operations[ops].ecceptions.param = meta.input[0].interfaces[i].operations[j].fault[m].type_name.name
              }
          }
       }
    }]











    /*genera l'interfaccia Client (da implementare aggiunta throws err1,err2...)*/
    [generateClientInterface( request )( response) {
       /*begin generazione interfaccia client del Servizio*/
       /*costruisci lista tipi complessi*/
       for (i = 0, i < #request.types, i++) {
            response += request.types[i].definition + "\n"
       };
       /*distinguo tra operazioni OneWay e RequestResponse e salvo in 2 array separati*/    
       for (i = 0, i < #request.operations, i++) {
          if (request.operations[i].response == void) {
              onewayOps[#onewayOps] << request.operations[i]
          } else {
              requestresponseOps[#requestresponseOps] << request.operations[i]
          }
       };
       response += "interface "+request.ms_name+"Interface {\n";
       /*costruisco lista operation OneWay*/
       response += " OneWay:\n";
       for (i = 0, i < (#onewayOps - 1), i++) {
            response += "   "+onewayOps[i].name+"("+onewayOps[i].request+ "),\n"
       };
       if (#onewayOps > 0) {
          response += "   "+onewayOps[i].name+"("+onewayOps[i].request+ ")\n"
       };
       /*costruisco lista operation RequestResponse*/
       response += " RequestResponse:\n";
       for (i = 0, i < (#requestresponseOps - 1), i++) {
            response += "   "+requestresponseOps[i].name+"("+requestresponseOps[i].request+ ")("+requestresponseOps[i].response+ "),\n"
       };
       if (#requestresponseOps > 0) {
         response += "   "+requestresponseOps[i].name+"("+requestresponseOps[i].request+ ")("+requestresponseOps[i].response+ ")\n"
       };
       response += "}\n\n";
       /*genera Outputport verso Gateway*/
       response += "outputPort " + request.ms_name + "_" + request.ms_id + " {\n";
       response += "  Location:\"socket://localhost:2002/!/" + request.ms_name + "_" + request.ms_id + "\"\n";
       response += "  Protocol:sodep\n";
       response += "  Interfaces: " + request.ms_name + "Interface\n";
       response += "}";
       println@Console("Generated Client Interface: \n\n" + response)()
       /*end generazione interfaccia client del Servizio*/
    }]











  /*genera rappresentazione in stringa del courier*/
  [generateCourier( request )( response ) {
      /*begin service interfaces include:*/
      response = "";
      for (i = 0, i < #request.subservices, i++) {
         for ( j = 0, j < #request.subservices[i].interfaces, j++ ) {
            /*begin find interface name with regex*/
            findinterfname = request.subservices[i].interfaces[j];
            findinterfname.regex = "(?:interface |vs\\. )(\\w+)"; //parola dopo 'interface'
            find@StringUtils(findinterfname)(interfname);
            request.subservices[i].interfaces[j].name = interfname.group[1];
            /*end find interface name with regex*/
            response += request.subservices[i].interfaces[j] + "\n\n"
         }
      };
      /*end service interfaces include:*/

      /*-------begin static content-------*/
      response += "\n\nexecution { concurrent }\n\n";
      response += "type AuthenticationData: any {\n";
      response += " .key:string\n";
      response += "}\n\n";
      response += "interface extender AuthInterfaceExtender {\n";
      response += " RequestResponse:\n";
      response += "    *( AuthenticationData )( void )\n";
      response += " OneWay:\n";
      response += "    *( AuthenticationData )\n";
      response += "}\n\n";
      response += "interface AggregatorInterface {\n";
      response += " RequestResponse:\n";
      response += "    mock(string)(string)\n";
      response += "}\n";
      /*-------end static content-------*/

      /*begin outputports generator */
      for (i = 0, i < #request.subservices, i++) {
            response += "outputPort SubService"+i+" {\n";
            response += " Interfaces: ";
            for ( j = 0, j < #request.subservices[i].interfaces - 1, j++ ) {
               response += request.subservices[i].interfaces[j].name + ", "
            };
            response += request.subservices[i].interfaces[j].name;
            response += "\n Location: \""+ request.subservices[i].location+ "\"\n";
            response += " Protocol: "+request.subservices[i].protocol+"\n";
            response += "}\n\n"
      };
      /*end outputports generator */

      /*-------begin static content-------*/
      response += "inputPort Client {\n";
      response += " Location: \"local\"\n";
      response += " Interfaces: AggregatorInterface\n";
      response += " Aggregates: ";
      /*-------end static content-------*/

      for (i = 0, i < #request.subservices - 1, i++) {
            if (#request.subservices)
            response += "SubService"+i+" with AuthInterfaceExtender, "
      };

      /*-------begin static content-------*/
      response += "SubService"+i+" with AuthInterfaceExtender ";
      response += "\n}\n\n";
      response += " courier Client {\n";
      /*-------end static content*/

      /*begin courier generator RequestResponse*/
      for (i = 0, i < #request.subservices, i++) {
         for ( j = 0, j < #request.subservices[i].interfaces, j++ ) {
            response += "    [ interface "+request.subservices[i].interfaces[j].name+"( request )( response ) ] {\n";
            response += "       forward ( request )( response )\n";
            response += "    }\n"
         }
      };
      /*end courier generator RequestResponse*/
      /*begin courier generator RequestResponse*/
      for (i = 0, i < #request.subservices, i++) {
         for ( j = 0, j < #request.subservices[i].interfaces, j++ ) {
            response += "    [ interface "+request.subservices[i].interfaces[j].name+"( request ) ] {\n";
            response += "       forward ( request )\n";
            response += "    }\n"
         }
      };
      /*end courier generator RequestResponse*/

      /*begin static content*/
      response += " }\n\n";
      response += "main {\n";
      response += " mock( r )( rs ) {\n";
      response += "    rs = void\n";
      response += " }\n";
      response += "}\n";
      println@Console("Generated courier: \n\n" + response)()
      /*end static content*/
   }]
}
