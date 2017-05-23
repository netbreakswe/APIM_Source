include "interfaces/microservices_dbInterface.iol"
include "interfaces/serviceinteractionhandlerinterface.iol"
include "interfaces/redirectorinterface.iol"

include "database.iol"
include "console.iol"
include "json_utils.iol"
include "converter.iol"
include "time.iol"


execution { sequential }


// porta per comunicare con gestore delle interazioni dei microservizi
outputPort ServiceInteractionHandler {
   Location: "socket://localhost:8322"
   Protocol: http 
   Interfaces: ServiceInteractionHandlerInterface
}

// porta per comunicare con Gateway
outputPort Gateway {
  Location: "socket://localhost:2002"
  Protocol: sodep
  Interfaces: RedirectorInterface
}

// basta questa port per comunicare con tutti i servizi
inputPort microservices_db_readerJSONInput {
  Location: "socket://localhost:8121"
  Protocol: http { 
    // Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins
    .response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
    .response.headers.("Access-Control-Allow-Origin") = "*";
    .response.headers.("Access-Control-Allow-Headers") = "Content-Type, Authorization";
    .format = "json"
  }
  Interfaces: microservices_dbInterface
}


// procedures per microservice_registration


// 1. Procedura che registra info base di un nuovo servizio nel db
define __save_Service {

	q_AF01k = "INSERT INTO microservices (Name,Description,Version,LastUpdate,IdDeveloper,Logo,DocPDF,DocExternal,
			  Profit,IsActive,SLAGuaranteed,Policy) VALUES (:n,:d,:v,:lu,:idv,:lg,:dp,:de,:pf,:isa,:sg,:py)";
	with( q_AF01k ) {
		.n = _Name;
        .d = _Description;
        .v = _Version;
        .lu = _LastUpdate;
        .idv = _IdDeveloper;
        .lg = _Logo;
        .dp = _DocPDF;
        .de = _DocExternal;
        .pf = _Profit;
        .isa = _IsActive;
        .sg = _SLAGuaranteed;
        .py = _Policy
    };
    update@Database( q_AF01k )( code_status_AF01k );
    println@Console( "Registering new microservice with name " + _Name + " by developer " + _IdDeveloper )();
    q_AF02k = "SELECT LAST_INSERT_ID() as id"; // ritorna l'id dell'interfaccia client
    query@Database( q_AF02k )( code_status_AF02k );
    _idms = int(code_status_AF02k.row[0].id);
    println@Console( "Api id " + _idms )()

}


// 2. Procedura che aggiunge l'interfaccia cliente generata nel db
define __save_Client_Interface {

	q_SLOP4I = "INSERT INTO clientinterf (IdMS,Interface, Interface_Meta) VALUES (:idms,:interf,:interf_meta)";
  	with( q_SLOP4I ) {
    	.idms = _idms;
    	.interf = _interf;
    	.interf_meta = _interf_meta
  	};
  	update@Database( q_SLOP4I )( result_q_SLOP4I );
  	println@Console( "Inserted Client Interface" )()

}


// 3. Procedura che aggiunge un interfaccia lato server nel db PRIVATA. serve per inizializzazione nuova API
define __interface_registration {

	// query per salvare un interfaccia
    _q = "INSERT INTO interfaces (IdMS,Interf,Loc,Protoc) VALUES (:IdMS,:Interf,:Loc,:Protoc)";
    update@Database( _q )( resultq_SLOP1I );
    println@Console( "Registering new interface of microservice " + _idms )()

}


// fine procedures per microservice_registration


init
{
	println@Console( "Microservices Db Microservice started" )();

  	// connect to microservices database (Heroku data)
 	with( connectionInfo ) {
 		.host = "u3y93bv513l7zv6o.chr7pe7iynqr.eu-west-1.rds.amazonaws.com"; 
        .driver = "mysql";
        .port = 3306;
        .database = "m1y8spip7s5ukrhr";
        .username = "zxxbfes4oykif53q";
        .password = "acngpm2x2ltntqbh"
    };
    connect@Database( connectionInfo )();
    println@Console("DB connected, connection is running on host:" + connectionInfo.host)()

}


main
{
    // Il gateway recupera tutte le info che gli servono per impostare le redirezioni dinamiche e creare courier 
    // PRE = (posso assumere che non ci sono inconsistenze a livello di database)
  	[retrieve_all_ms_gateway_meta( request )( response ) {

  		// query
    	q = "SELECT microservices.idMS,microservices.Name,interfaces.Interf,interfaces.Loc,interfaces.Protoc 
    		FROM interfaces,microservices WHERE interfaces.idMS=microservices.idMS ORDER BY microservices.idMS ASC";
    	query@Database(q)(result);

    	service_index = -1; currId = "";
    	for( i=0, i<#result.row, i++ ) {
        // diverso id vuol dire che ho altro servizio
	      if(currId != result.row[i].Name + "_" + result.row[i].idMS) {
          currId = result.row[i].Name + "_" + result.row[i].idMS;
          service_index++; 
          response.services[service_index] << currId
        };
        // controllo se la location di questa riga è uguale a quella di subservizi precedenti
        j = 0; trovato = false;
        while( j<#response.services[service_index].subservices && !trovato ) {
          if(response.services[service_index].subservices[j].location == result.row[i].Loc) {
            trovato = true
          } 
          else {
            j++
          }
        };        
        if(!trovato) {
          // se location mai trovata nei subservice precedente ho un nuovo subservice
          subservice_index = #response.services[service_index].subservices;
          interf_index = #response.services[service_index].subservices[subservice_index].interfaces;
          response.services[service_index].subservices[subservice_index].location << result.row[i].Loc;
          response.services[service_index].subservices[subservice_index].protocol << result.row[i].Protoc;
          response.services[service_index].subservices[subservice_index].interfaces[interf_index] << result.row[i].Interf
        } 
        // se la location trovata nei subservice precedenti aggiungi interfaccia a quel subservice dove trovata
        else {
          interf_index = #response.services[service_index].subservices[j].interfaces;
          response.services[service_index].subservices[j].interfaces[interf_index] << result.row[i].Interf
        }
    	}

  	}]
  	// POST = (ritorna le info per fare il binding a livello di gateway)




  	// Recupera tutte le info relative all'interfaccia client di un servizio i (per web app)
  	[retrieve_client_interface_from_id( request )( response ) {

  		// query
    	q = "SELECT * FROM clientinterf WHERE idMS=:idms";
    	with( q ) {
        .idms = request.Id
    	};
    	query@Database( q )( result );
    
	    // dati interfaccia salvati come json pertanto decodifico e incapsulo in response
	    getJsonValue@JsonUtils(result.row[0].Interface_Meta)(meta_service_value);
	    for( i=0, i<#meta_service_value.operations, i++ ) {
	    	response.operations[i].name = meta_service_value.operations[i].name;
	      response.operations[i].request = meta_service_value.operations[i].request;
	     	response.operations[i].response = meta_service_value.operations[i].response;
	      if( meta_service_value.operations[i].description != void) {
          response.operations[i].description = meta_service_value.operations[i].description
	      };
	      for( j=0, j<#meta_service_value.operations[i].ecceptions, j++ ) {
          response.operations[i].ecceptions[j].name = meta_service_value.operations[i].ecceptions[j].name;
          response.operations[i].ecceptions[j].param = meta_service_value.operations[i].ecceptions[j].param
	      }
	    };
	    for( i=0, i<#meta_service_value.types, i++ ) {
        response.types[i].name = meta_service_value.types[i].name;
	      response.types[i].definition = meta_service_value.types[i].definition
	    };
	    response.client_Interface = result.row[0].Interface

  	}]




  	// recupera tutte le info di base di un microservizio i (per web app)
  	[retrieve_ms_info( request )( response ) {

		  // query
    	q = "SELECT * FROM microservices WHERE IdMS=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if( #result.row == 0 ) {
        println@Console("Microservice not found")()
    	}
    	else {
        for ( i=0, i<#result.row, i++ ) {
        	println@Console( "Got microservice with id "+ request.Id )();
        	response << result.row[i]
     		}
    	};
   		println@Console("Retrieved all info about microservice " + response.Name)()

  	}]




  	// recupera tutte le info di un interfaccia
  	[retrieve_intf_info( request )( response ) {

    	// query
	    q = "SELECT Interf,Loc,Protoc FROM interfaces WHERE IdInterface=:i";
	    q.i = request.Id;
	    query@Database( q )( result );

	    if ( #result.row == 0 ) {
	    	println@Console("Interface not found")()
	    }
	    else {
	    	for( i=0, i<#result.row, i++ ) {
	        println@Console( "Got interface with id " + request.Id )();
	        response << result.row[i]
	      }
	    };
	    println@Console("Retrieved interface gateway info (interface)(location:" + response.Loc + ")(protocol" + response.Protoc + ")" )()

  	}]




  	// recupera tutte le info delle interfacce di un servizio associate ai rispettivi subservizi (per developers)
  	[retrieve_interfaces_of_ms( request )( response ) {

  		// query
    	q = "SELECT microservices.idMS,microservices.Name,interfaces.Interf,interfaces.Loc,interfaces.Protoc 
    		FROM interfaces,microservices WHERE interfaces.IdMS=:idMS AND microservices.IdMS=:idMS;";
    	with ( q ) {
       	.idMS = request.Id
    	};
    	query@Database(q)(result);

    	for( i=0, i<#result.row, i++ ) {
        // controllo se la location di questa riga e' uguale a quella di subservizi precedenti
        j = 0; trovato = false;
        while( j<#response.subservices && !trovato ) {
          if(response.subservices[j].location == result.row[i].Loc) {
            trovato = true
          } 
          else {
            j++
          }
        };        
        if(!trovato) {
          // se la location non è stata mai trovata nei subservice precedente è un nuovo subservice
	         subservice_index = #response.subservices;
	         interf_index = #response.subservices[subservice_index].interfaces;
	         response.subservices[subservice_index].location = result.row[i].Loc;
	         response.subservices[subservice_index].protocol = result.row[i].Protoc;
	         response.subservices[subservice_index].interfaces[interf_index] = result.row[i].Interf
        } 
        // se la location è stata trovata nei subservice precedenti aggiunge l'interfaccia a quel subservice
        else {
          interf_index = #response.subservices[j].interfaces;
          response.subservices[j].interfaces[interf_index] = result.row[i].Interf
        }
    	}

  	}]




  	// recupera l'id  di un servizio a partire dall'interfaccia
  	[retrieve_ms_from_interface( request )( response ) {

   		// query
    	q = "SELECT IdMS FROM interfaces WHERE IdInterface=:i";
	    q.i = request.Id;
	    query@Database( q )( result );

	    if( #result.row==0 ) {
	    	println@Console("Microservice not found")()
	    }
	    else {
	    	for( i=0, i<#result.row, i++ ) {
	        println@Console( "Got microservice "+ result.row[i].IdMS )();
	        response << result.row[i]
	      }
	    };
	    println@Console("Retrieved microservice " + response.IdMS + " from interface " + request.Id)()

  	}]




  	// recupera alcuni dati dei servizi di uno specifico developer id
  	[retrieve_ms_from_developerid( request )( response ) {

    	// query
    	q = "SELECT IdMS,Name,Logo,IsActive FROM microservices WHERE IdDeveloper=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if( #result.row==0 ) {
      	println@Console("Microservice not found")()
    	}
    	else {
      	for( i=0, i<#result.row, i++ ) {
        	println@Console( "Got microservice "+ result.row[i].IdMS )();
        	response.msdevdata[i].IdMS = result.row[i].IdMS;
        	response.msdevdata[i].Name = result.row[i].Name;
        	response.msdevdata[i].Logo = result.row[i].Logo;
				  response.msdevdata[i].IsActive = result.row[i].IsActive
      	}
   		};
    	println@Console("Retrieved microservice id from developer id")()

  	}]




  	// ritorna i dati di una singola categoria
  	[retrieve_category_info( request )( response ) {

    	// query
    	q = "SELECT IdCategory,Name,Image,Description FROM categories WHERE IdCategory=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if( #result.row==0 ) {
    		println@Console("Category not found")()
    	}
    	else {
      	for( i=0, i<#result.row, i++ ) {
        	println@Console( "Got category with id "+ request.Id )();
        	response << result.row[i]
      	}
    	};
    	println@Console("Retrieved category " + response.CategoryData.Name)()

  	}]




  	// ritorna tutta la lista di categorie disponibili in apim
  	[retrieve_category_list( request )( response ) {

  		// query
    	q = "SELECT IdCategory,Name,Image FROM categories";
    	query@Database( q )( result );

    	for( i=0, i<#result.row, i++ ) {
      	response.categories[i].IdCategory = result.row[i].IdCategory;
      	response.categories[i].Name = result.row[i].Name; 
      	response.categories[i].Image = result.row[i].Image
    	};
    	println@Console("Retrieved categories")()

  	}]




  	// ritorna tutti gli id delle categorie di un servizio i
  	[retrieve_categories_of_ms( request )( response ) {

    	// query
    	q = "SELECT IdCategory,Name,Image,Description FROM jnmscat NATURAL JOIN categories WHERE IdMS=:i";
    	q.i = request.Id;
   		query@Database( q )( result );

    	if( #result.row==0 ) {
      	println@Console("Microservice not found")()
    	}
    	else {
      	for( i=0, i<#result.row, i++ ) {
        	println@Console( "Got category number " + i )();
        	response.categorydatalist[i] << result.row[i]
      	}
    	};
    	println@Console("Retrieved categories of the microservice with id" + request.Id)()

  	}]




  	// recupera info di tutti i servizi con categorie associate per la home presentation
  	[homepage_ms_list( request )( response ) {

    	// query
    	q = "SELECT microservices.IdMS,microservices.Name,microservices.IdDeveloper,microservices.Logo,categories.IdCategory,categories.Name 
    		AS CatName FROM microservices JOIN jnmscat JOIN categories ON jnmscat.IdMs=microservices.IdMS 
    		AND jnmscat.IdCategory=categories.IdCategory ORDER BY IdMS ASC ";
    	query@Database( q )( result );

    	idms = -1; 
    	s_i = #response.services; // microservizio corrente + index ms corrente
    
    	// scorre righe del risultato
    	for( i=0, i<#result.row, i++ ) {
       	// salva le info del servizio se ho un nuovo servizio
       	if(result.row[i].IdMS != idms) {
          idms = result.row[i].IdMS; // salva l'id del microservizio corrente
          s_i = #response.services; // ricava l'indice dove inserire il nuovo servizio
          response.services[s_i].Name = result.row[i].Name;
          response.services[s_i].Logo = result.row[i].Logo;
	        response.services[s_i].IdMS = result.row[i].IdMS;
          response.services[s_i].IdDeveloper = result.row[i].IdDeveloper;
          c_i = #response.services[s_i].categories; // ricava l'indice dove inserire la categoria
          response.services[s_i].categories[c_i].IdCategory = result.row[i].IdCategory;
          response.services[s_i].categories[c_i].CatName = result.row[i].CatName
        } 
        else {
          c_i = #response.services[s_i].categories; // ricava l'indice dove inserire la categoria
          println@Console(result.row[i].IdCategory)();
          response.services[s_i].categories[c_i].IdCategory = result.row[i].IdCategory;
          response.services[s_i].categories[c_i].CatName = result.row[i].CatName
        }
      }

  	}]




  	// metodo per aggiungere API (manca la gestione errori)
  	[microservice_registration( request )( response ) {

	    // 1. converte il data raw in arrivo in un json string:
	    rawToString@Converter( request.data )( json );
	    // 2. ottiene dati della API aggiunta(anche molto complessi) dal json ricevuto dalla web app:
	    getJsonValue@JsonUtils(json)(api);
	    // 3. salva i dati nella richiesta da fare al generatore di courier
	    for( i=0, i<#api.subservices, i++ ) {
	    	courier_data.subservices[i].location = api.subservices[i].location;
	      courier_data.subservices[i].protocol = api.subservices[i].protocol;
	      for( j=0, j<#api.subservices.interfaces, j++ ) {
	      	if( api.subservices[i].interfaces[j] != null ) {
	      		courier_data.subservices[i].interfaces[j] = api.subservices[i].interfaces[j]
	         }
	      }      
	    };
	    courier_data = "mockid"; 
	    getDateTime@Time( 0 )( date ); // data corrente
	    // 4. salva gli altri dati relativi alla API dal json in arrivo
	    _Name = api.Name; _Description = api.Description; _Version = 1;
	    _LastUpdate = date.year + "-" + date.month + "-" + date.day;
	    _IdDeveloper = api.IdDeveloper; _Logo = api.Logo; _DocPdf = api.DocPdf;
	    _DocExternal = api.DocExternal; _Profit = api.Profit; _IsActive = true;
	    _SLAGuaranteed = 1; _Policy = api.Policy;
	    // 5. genera temp Courier
	    generateCourier@ServiceInteractionHandler(courier_data)(courier_string);
	    println@Console("Generated courier")();
	    // 6. scrive courier su file temporaneo
	    getRandomUUID@StringUtils()( random );
	    with( file_request ) {
        .content = courier_string;
        .filename = "temp_couriers/" + random + ".ol" // la cartella 'temp_couriers' deve esistere in questa directory
	    };
	    writeFile@File(file_request)();
	    // 7. ricava meta-dati da courier
	    getServiceMetaFromCourier@ServiceInteractionHandler( file_request.filename )( meta_info_service );
	    // 8. sicuramente non presenti errori di sintassi (error checking non implementato) 
	    // 9. cancella Courier temporaneo
	    deleteDir@File(file_request.filename)(deleted);
	    // 10. salva info servizio nel db
	    __save_Service;
	    // 11. genera l'interfaccia Client
	    meta_info_service.ms_id = _idms; // id servizio
	    meta_info_service.ms_name = _Name; // nome servizio
	    generateClientInterface@ServiceInteractionHandler( meta_info_service )( client_i_string );
	    println@Console("Generated Client Interface")();
	    // 12. salva interfaccia client nel db
	    _interf -> client_i_string; //
	    getJsonString@JsonUtils( meta_info_service )( json_info_service ); // converte meta info in json_string
	    _interf_meta = json_info_service; // json_string che contiene meta-info estratte precedentemente relative all'interfaccia
	     __save_Client_Interface;
	    // 13. salva le interfacce originali con info di binding (lato server affinchè il gateway redirecti al servizio corretto)
	    for( i=0, i<#courier_data.subservices, i++ ) {
	    	for( j=0, j<#courier_data.subservices[i].interfaces, j++ ) {
	    		with( _q ) {
	    			.IdMS = _idms;
            .Interf = courier_data.subservices[i].interfaces[j];
            .Loc = courier_data.subservices[i].location;
            .Protoc = courier_data.subservices[i].protocol
          };
          __interface_registration
	      }
	    };
	    // 14. aggiunge al db la lista delle categorie dell'API
	    for( i=0, i<#api.categories, i++ ) {
	    	q = "INSERT INTO jnmscat (IdMS,IdCategory) VALUES (:ims,:c)";
        with( q ) {
          .ims = _idms;
          .c = api.categories[i]
        };
        update@Database( q )( status )
	    };
	    // 15. imposta nuova redirezione sul gateway per il servizio
	    gateway_req = meta_info_service.ms_name + "_" + meta_info_service.ms_id;
	    gateway_req.subservices << courier_data.subservices;
	    setnewredirection@Gateway( gateway_req )();
	    // 16. ritorna l'id del nuovo servizio
	    response = _idms

  	}]




  	// aggiorna info base di un microservizio
  	[microservice_update( request )( response ) {

    	// query
    	q = "UPDATE microservices SET Name=:n,Description=:d,Version=:v,LastUpdate=:lu,Logo=:lg,DocPDF=:dp,
      		DocExternal=:de,Profit=:pf,SLAGuaranteed=:sg WHERE IdMS=:i";
    	with( request ) {
      	q.i = .IdMS;
      	q.n = .Name;
      	q.d = .Description;
		    q.v = .Version;
		    q.lu = .LastUpdate;
		    q.lg = .Logo;
		    q.dp = .DocPDF;
		    q.de = .DocExternal;
		    q.pf = .Profit;
		    q.sg = .SLAGuaranteed
    	};
    	update@Database( q )( result );
    	println@Console("Updating microservice with id " + request.IdMS)()

  	}]




  	[interface_update( request )( response ) {

    	// query
    	q = "UPDATE interfaces SET Interf=:i,Loc=:l,Protoc=:p WHERE IdInterface=:ii";
    	with( q ) {
      	.ii = request.IdInterface;
      	.i = request.Interf;
      	.l = request.Loc;
      	.p = request.Protoc
    	};
   		update@Database( q )( result );
    	println@Console( "Updating interface " + request.IdInterface )()

  	}]




  	[add_category_to_ms( request )( response ) {

	    //query
	    q = "INSERT INTO jnmscat (IdMS,IdCategory) VALUES (:ims,:c)";
	    with( request ) {
	    	q.ims = .IdMS;
	      	q.c = .IdCategory
	    };
	    update@Database( q )( result );
	    println@Console( "Adding a new category to microservice " + request.IdMS )()

  	}]




  	[remove_category_from_ms( request )( response ) {

   		// query
    	q = "DELETE FROM jnmscat WHERE IdMS=:ims AND IdCategory=:c";
    	with( request ) {
     		q.ims = .IdMS;
      	q.c = .IdCategory
    	};
    	update@Database( q )( result );
    	println@Console( "Removing category from microservice " + request.IdMS )()

  	}]




   	// update di tutte le info relative all'interfaccia client del servizio corrispondente all'id (per web app)
  	[update_client_interface_by_id( request )( response ) {

	  	println@Console("Received client interface update request")();
	    rawToString@Converter( request.data )( json );
	    // dati interfaccia salvati come json pertanto decodifica e incapsula in response
	    getJsonValue@JsonUtils(json)(meta_service_value);
	    for( i=0, i<#meta_service_value.operations, i++ ) {
	    	client_I.operations[i].name = meta_service_value.operations[i].name;
	      client_I.operations[i].request = meta_service_value.operations[i].request;
	      client_I.operations[i].response = meta_service_value.operations[i].response;
	      client_I.operations[i].description = meta_service_value.operations[i].description;
	      for( j=0, j<#meta_service_value.operations[i].ecceptions, j++ ) {
	      	client_I.operations[i].ecceptions[j].name = meta_service_value.operations[i].ecceptions[j].name;
	         client_I.operations[i].ecceptions[j].param = meta_service_value.operations[i].ecceptions[j].param
	      }
	    };
	    for( i=0, i<#meta_service_value.types, i++ ) {
	    	client_I.types[i].name = meta_service_value.types[i].name;
	     	client_I.types[i].definition = meta_service_value.types[i].definition
	    };
	    getJsonString@JsonUtils(client_I)(client_I_jsonstring);

	    // query
	    q = "UPDATE clientinterf SET Interface_Meta=:i_meta WHERE IdMS=:idms;";
	    with(q) {
	    	.idms = request.Id;
	      .i_meta = client_I_jsonstring
	    };
	    update@Database( q )( result_A1 );
	    println@Console("client interface updated")()

  	}]


}