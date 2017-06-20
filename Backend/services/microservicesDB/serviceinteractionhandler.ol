include "console.iol"

include "interfaces/serviceinteractionhandlerinterface.iol"


execution { concurrent }


inputPort ServiceInterationHandler {
   Location: "socket://localhost:8322"
   Protocol: http 
   Interfaces: ServiceInteractionHandlerInterface
}


// 1. Procedura che determina se _T sia già presente in array _arr
define __isInArrayAndPos {
	_trovato = false;
  	_pos = 0;
  	while( _pos < #_arr && !_trovato ) {
    	if (_arr[_pos] == _T) {
        	_trovato = true
      	} 
      	else {
        	_pos++
      	}
  	}
}

// 2. manca check su apikey e sla survey (dipendenti da acquisto)


init 
{
	// lista di tutti i tipi primitivi in Jolie
  	primitive[ 0 ] = "bool"; primitive[ 1 ] = "int"; primitive[ 2 ] = "long"; primitive[ 3 ] = "double";
  	primitive[ 4 ] = "string"; primitive[ 5 ] = "raw"; primitive[ 6 ] = "void"; primitive[7] = "any";
  	primitive[ 8 ] = "undefined"
}

main 
{


	// 1. da gestire il controllo correttezza interfacce
    // 2. se ci sono tipi con nomi uguale ma implementazione diversa  
    // 3. se ci sono operation con nome uguale ma tipi diversi 

	[getServiceMetaFromCourier( request )( response ) {

		    metareq.name.name = "Client"; metareq.name.domain = "gateway"; metareq.filename = request;
      	// ottiene meta dati in formato MetaJolie
      	getInputPortMetaData@MetaJolie( metareq )( meta );
      	// ricava tutte le metainformazioni circa servizio APIM
      	primitiveextention = 0; // numero tipi primitivi distinti nelle request delle operation
      	//  tutte le interfacce
      	for( i=0, i<#meta.input[0].interfaces, i++ ) {
      		// scorre i tipi complessi dell'interfaccia i
          	for( k=0, k<#meta.input[0].interfaces[i].types, k++ ) {
          		// controlla se questo tipo complesso sia stato già incontrato
             	_T -> meta.input[0].interfaces[i].types[k].name.name;
             	_arr -> response.types;
             	__isInArrayAndPos;
             	// se tipo con questo nome non incontrato salva in array
             	if(!_trovato) {
                	pos = #response.types;
                	response.types[pos] << meta.input[0].interfaces[i].types[k].name.name;
                	response.types[pos].name << meta.input[0].interfaces[i].types[k].name.name;
                	getType@Parser(meta.input[0].interfaces[i].types[k])(complextype);
                	response.types[pos].definition << complextype
             	} 
          	};
          	// scorre le operation dell'interfaccia i
          	for( j=0, j<#meta.input[0].interfaces[i].operations, j++ ) {
            	ops = #response.operations;
             	response.operations[ops].name << meta.input[0].interfaces[i].operations[j].operation_name; // nome operation j
             	// controlla se il tipo della richiesta dell'operation j dell'interfaccia i sia tipo primitivo
             	_T -> meta.input[0].interfaces[i].operations[j].input.name;
             	_arr -> primitive;
             	__isInArrayAndPos;
             	// se primitivo
             	if(_trovato) {
             		// controlla se il tipo primitivo sia stato già incontrato
                	_arr -> response.types;
                	__isInArrayAndPos;
                	// se tipo non incontrato lo salva in array response.types
                	if(!_trovato) {
                		pos = #response.types;
                    response.types[pos] << _T;
                    response.types[pos].name << "t" + primitiveextention; // nome esteso
                    response.types[pos].definition << "type t" + primitiveextention + ": " + response.types[pos] + 
	                   		" {\n .key: string \n .user: string \n .api: int\n}";
                    response.operations[ops].request << response.types[pos].name;
                    primitiveextention++

                	// se il tipo è già stato incontrato
                	} 
                	else {
                  		response.operations[ops].request << response.types[_pos].name
                	}
              	}
              	// altrimenti salva in operations il nome del tipo complesso del tipo di andata dell'operation j
              	else {
                	response.operations[ops].request << _T
              	};
              	// salva in in operations il tipo di ritorno dell'operation j
              	response.operations[ops].response << meta.input[0].interfaces[i].operations[j].output.name;
              	for( m=0, m<meta.input[0].interfaces[i].operations[j].fault[m], m++ ) {
              		response.operations[ops].ecceptions.name = meta.input[0].interfaces[i].operations[j].fault[m].name;
                	response.operations[ops].ecceptions.param = meta.input[0].interfaces[i].operations[j].fault[m].type_name.name
              	}
          	}
       	}

    }]




    // genera l'interfaccia Client (da implementare aggiunta throws err1,err2...)
    [generateClientInterface( request )( response) {

    	// begin generazione interfaccia client del servizio

       	// costruisce la lista dei tipi complessi
       	for( i=0, i<#request.types, i++ ) {
       		response += request.types[i].definition + "\n"
       	};
       	// distingue tra operazioni OneWay e RequestResponse e salva in 2 array separati    
       	for( i=0, i<#request.operations, i++ ) {
       		if(request.operations[i].response == void) {
            	onewayOps[#onewayOps] << request.operations[i]
          	} 
          	else {
          		requestresponseOps[#requestresponseOps] << request.operations[i]
          	}
       	};
       	response += "interface "+request.ms_name+"Interface {\n";
       	// costruisce la lista di operation OneWay
       	response += " OneWay:\n";
       	for( i=0, i<(#onewayOps), i++ ) {
       		response += "   "+onewayOps[i].name+"("+onewayOps[i].request+ "),\n"
       	};
       	if( #onewayOps>0 ) {
       		response += "   "+onewayOps[i].name+"("+onewayOps[i].request+ ")\n"
       	};
       	// costruisce lista di operation RequestResponse
       	response += " RequestResponse:\n";
       	for( i=0, i<(#requestresponseOps), i++ ) {
            response += "   "+requestresponseOps[i].name+"("+requestresponseOps[i].request+ ")("+requestresponseOps[i].response+ "),\n"
       	};
       	if (#requestresponseOps>0 ) {
         	response += "   "+requestresponseOps[i].name+"("+requestresponseOps[i].request+ ")("+requestresponseOps[i].response+ ")\n"
       	};
       	response += "}\n\n";
       	// genera Outputport verso Gateway
       	response += "outputPort " + request.ms_name + "_" + request.ms_id + " {\n";
       	response += "  Location:\"socket://localhost:2002/!/" + request.ms_name + "_" + request.ms_id + "\"\n";
       	response += "  Protocol:sodep\n";
       	response += "  Interfaces: " + request.ms_name + "Interface\n";
       	response += "}";

       	println@Console("Generated Client Interface: \n\n" + response)()
       	// end generazione interfaccia client del Servizio

    }]





  	// genera rappresentazione in stringa del courier
  	[generateCourier( request )( response ) {

  		response = "";

  		// include transactionsdb per la validazione delle chiamate
  		response += "include \"transactions_path.ol\"\n";

  		// include sladb per la gestione della sla nelle chiamate
  		response += "include \"sla_path.ol\"\n";

  		// include microservicesdb per iscompliant e policies
  		response += "include \"microservices_path.ol\"\n\n";

  		// include time per i timestamp
  		response += "include \"time.iol\"\n";

  		// include console per print varie
  		response += "include \"console.iol\"\n\n";

      	// include calcMessage
      	response += "include \"calcMessage_path.ol\"\n\n";


		// begin service interfaces include:
      	for( i=0, i<#request.subservices, i++ ) {
      		for( j=0, j<#request.subservices[i].interfaces, j++ ) {
          		// begin find interface name with regex
          		findinterfname = request.subservices[i].interfaces[j];
          		findinterfname.regex = "(?:interface |vs\\. )(\\w+)"; // parola dopo interface
          		find@StringUtils(findinterfname)(interfname);
          		request.subservices[i].interfaces[j].name = interfname.group[1];
          		// end find interface name with regex
          		response += request.subservices[i].interfaces[j] + "\n\n"
        	}
      	};
      	// end service interfaces include:

      	// -------begin static content-------
      	response += "type AuthenticationData: any {\n";
      	response += " .key: string\n";
      	response += " .user: string\n";
      	response += " .api: int\n";
      	response += "}\n\n";
      	response += "interface extender AuthInterfaceExtender {\n";
      	response += "  RequestResponse:\n";
      	response += "    *( AuthenticationData )( void )\n";
      	response += "  OneWay:\n";
      	response += "    *( AuthenticationData )\n";
      	response += "}\n\n";
        response += "interface AggregatorInterface {\n";
        response += "  RequestResponse:\n";
      	response += "    mock( string )( string )\n";
      	response += "}\n\n";
      	// -------end static content-------


      	// transactionsdb outputport (per la validazione user+key)	
      	response += "outputPort transactions_dbOutput {\n";
  		  response += " Location: \"socket://localhost:8131\"\n";
  		  response += " Protocol: http\n";
  		  response += " Interfaces: transactions_dbInterface\n";
  		  response += "}\n\n";

		    // sladb outputport (per la gestione SLA)	
      	response += "outputPort sla_dbOutput {\n";
  		  response += " Location: \"socket://localhost:8141\"\n";
  		  response += " Protocol: http\n";
  		  response += " Interfaces: sla_dbInterface\n";
		    response += "}\n\n";

		    // microservicesdb outputport (per iscompliant e policies)
      	response += "outputPort microservices_dbOutput {\n";
  		  response += " Location: \"socket://localhost:8121\"\n";
  		  response += " Protocol: http\n";
  		  response += " Interfaces: microservices_dbInterface\n";
		    response += "}\n\n";

        // calcMessage outputport
        response += "outputPort calcMessageOutput {\n";
        response += " Interfaces: calcMessageInterface\n";
        response += "}\n\n";

        // calcMessage embedding
        response += "embedded {\n";
        response += " Java: \"jolie.calcMessage.calcMessage\" in calcMessageOutput\n";
        response += "}\n\n";

      	// begin outputports generator

      	for( i=0, i<#request.subservices, i++ ) {
      		response += "outputPort SubService"+i+" {\n";
          	response += " Interfaces: ";
          	for( j=0, j<#request.subservices[i].interfaces - 1, j++ ) {
            	response += request.subservices[i].interfaces[j].name + ", "
          	};
          	response += request.subservices[i].interfaces[j].name;
          	response += "\n Location: \""+ request.subservices[i].location+ "\"\n";
          	response += " Protocol: "+request.subservices[i].protocol+"\n";
          	response += "}\n\n"
      	};

      	// end outputports generator

     	  // -------begin static content-------
     	  response += "inputPort Client {\n";
      	response += " Location: \"local\"\n";
      	response += " Interfaces: AggregatorInterface\n";
      	response += " Aggregates: ";
      	// -------end static content-------

      	for( i=0, i<#request.subservices - 1, i++ ) {
      		if(#request.subservices) {
        		response += "SubService"+i+" with AuthInterfaceExtender, "
      		}
      	};

      	// -------begin static content-------
      	response += "SubService"+i+" with AuthInterfaceExtender ";
      	response += "\n}\n\n";
      	response += " courier Client {\n";
      	// -------end static content-------

		    // begin courier generator RequestResponse
      	for( i=0, i<#request.subservices, i++ ) {
        	for( j=0, j<#request.subservices[i].interfaces, j++ ) {
          		response += "  [ interface "+request.subservices[i].interfaces[j].name+"( request )( response ) ] {\n";
          		
          		// error handling
          		response += "    install( RequestNotValid =>\n";
          		response += "    	println@Console( \"Request not valid!\" )()\n";
          		response += "    );";
				

          		// memorizza info della request
          		response += "    requestinfo.APIKey = request.key;\n";
          		response += "    requestinfo.IdClient = request.user;\n";
          		response += "    requestinfo.IdMS = request.api;\n";

          		// organizza dati per il check apikey
          		response += "    check.APIKey = requestinfo.APIKey;\n";
          		response += "    check.IdClient = requestinfo.IdClient;\n";
          		response += "    check.IdMS = requestinfo.IdMS;\n";

				// check apikey
          		response += "    check_apikey_exists@transactions_dbOutput( check )( validity );\n";

          		// check isactive
          		response += "    checkisactive.Id = requestinfo.IdMS;\n";
          		response += "    check_ms_isactive@microservices_dbOutput( checkisactive )( availability );\n";

          		// controllo validità e se sia attivo
          		response += "    if( validity && availability ) {\n";

          		// chiamata valida

          		// assegnazioni generiche allo sla survey
          		response += "      slasurvey.APIKey = requestinfo.APIKey;\n";
          		response += "      slasurvey.IdMS = requestinfo.IdMS;\n";

          		// calcola timestamp pre-forward
          		response += "      getCurrentTimeMillis@Time( void )( currmillis );\n";
          		response += "      slasurvey.Timestamp = currmillis;\n";

          		// forward
          		response += "      forward( request )( response );\n";

          		// calcola response time post-forward
          		response += "      getCurrentTimeMillis@Time( void )( responsemillis );\n";
          		response += "      responsetime = responsemillis - currmillis;\n";
          		response += "      slasurvey.ResponseTime = responsetime;\n";

          		// calcola se la sla garantita sia rispettata
          		response += "      callcompliance.IdMS = requestinfo.IdMS;\n";
          		response += "      callcompliance.Number = responsetime;\n";
              	response += "      check_ms_iscompliant@microservices_dbOutput( callcompliance )( compliance );\n";
          		response += "      slasurvey.IsCompliant = compliance;\n";

          		// operazioni riguardanti policy e remaining (se la SLA è rispettata scala il remaining, altrimenti no)
          		response += "      if( compliance ) {\n";
          		response += "        callidms.Id = requestinfo.IdMS;\n";
          		response += "        retrieve_ms_policy@microservices_dbOutput( callidms )( policy );\n";
          		response += "        remaininginfo.APIKey = requestinfo.APIKey;\n";

          		// policy per numero di chiamate
          		response += "        if( policy == 1 ) {\n";
          		response += "          remaininginfo.Number = -1\n";
          		response += "        }\n";

          		// policy per tempo di utilizzo
		  		response += "        else if( policy == 2 ) {\n";
          		response += "          remaininginfo.Number = 0 - responsetime;\n";
              	response += "          if(remaininginfo.Number == 0) {\n";
              	response += "            remaininginfo.Number = -1\n";
              	response += "          }\n";
          		response += "        }\n";

          		// policy per traffico dati (da implementare)

				response += "        else if( policy == 3 ) {\n";
				response += "          calcMessage@calcMessageOutput( request )( reqtraffic );\n";
				response += "          calcMessage@calcMessageOutput( response )( resptraffic );\n";
				response += "          println@Console( \"Reqtraffic: \" + reqtraffic.bytesize )();\n";
				response += "          println@Console( \"Resptraffic: \" + resptraffic.bytesize )();\n";
          		response += "          remaininginfo.Number = 0 - (reqtraffic.bytesize + resptraffic.bytesize);\n";
          		response += "          if(remaininginfo.Number == 0) {\n";
              	response += "            remaininginfo.Number = -1\n";
              	response += "          }\n";
                response += "        };\n";

          		// aggiornamento del remaining

          		response += "        apikey_remaining_update@transactions_dbOutput( remaininginfo )( void )\n";
          		response += "      };\n";

          		// archivia lo sla survey
          		response += "	   slasurvey_insert@sla_dbOutput( slasurvey )( void )\n";
          		response += "    }\n";

          		// chiamata non valida
          		response += "    else {\n";
          		response += "      throw( RequestNotValid )\n";
          		response += "    }\n";

          		// parentesi finale
          		response += "  }\n"
        	}
      	};
      	// end courier generator RequestResponse

      	// begin courier generator Request
      	for( i=0, i<#request.subservices, i++ ) {
        	for( j=0, j<#request.subservices[i].interfaces, j++ ) {
         		response += "  [ interface "+request.subservices[i].interfaces[j].name+"( request ) ] {\n";
          		response += "    forward ( request )\n";
          		response += "  }\n"
        	}
      	};
      	// end courier generator Request

      	// begin static content
      	response += " }\n\n";
      	response += "main {\n";
      	response += "  mock( r )( rs ) {\n";
      	response += "    rs = void\n";
      	response += "  }\n";
      	response += "}\n";
      	println@Console("Generated courier: \n\n" + response)()
      	// end static content

   	}]


}
