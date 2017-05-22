include "interfaces/transactions_dbInterface.iol"

include "database.iol"
include "console.iol"
include "string_utils.iol"


execution { sequential }


// basta questa port per comunicare con tutti i servizi
inputPort transactions_dbJSONInput {
  Location: "socket://localhost:8131"
  Protocol: http { 
    // Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins
    .response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
    .response.headers.("Access-Control-Allow-Origin") = "*";
    .response.headers.("Access-Control-Allow-Headers") = "Content-Type, Authorization";
    .format = "json"
  }
  Interfaces: transactions_dbInterface
}

// 1. procedura che verifica se l'api key generata sia univoca 
define __checkIfAPIKeyUnique {
	// query
	q_45_Y = "SELECT * FROM apikeys WHERE APIKey=:api";
  	q_45_Y.api = _API_45_Y;
  	query@Database( q_45_Y )( result_45_Y );
  	if (#result_45_Y.row == 0) {
  		_unique_45_Y = true
  	} 
  	else {
  		_unique_45_Y = false
  	}
}


init
{
	println@Console( "Transactions Db Microservice started" )();

  	// connect to transactions database (heroku)
 	with( connectionInfo ) {
 	 	.host = "zwgaqwfn759tj79r.chr7pe7iynqr.eu-west-1.rds.amazonaws.com"; 
      	.driver = "mysql";
      	.port = 3306;
      	.database = "yugmcjcg2hvudvwd";
      	.username = "z4c0c7kulqkmnvkk";
      	.password = "l68qvsy16uyg7e44"
    };
    connect@Database( connectionInfo )();
    println@Console("DB connected, connection is running on host:" + connectionInfo.host )()
}


main
{


	// controlla esistenza apikey
  	[apikey_exists( request )( response ) {
    	_API_45_Y = random;
    	__checkIfAPIKeyUnique;
     	if (_unique_45_Y) {
      		response = true;
      		println@Console( "Exists" )()
    	} 
    	else {
      		response = false;
      		println@Console( "Not Exists")()
    	}
  	}]



  	// recupera gli attributi di una apikey a partire dalla sua stringa univoca
  	[retrieve_apikey_info( request )( response ) {

    	//query
    	q = "SELECT APIKey,IdMS,IdClient,Remaining FROM apikeys WHERE APIKey=:ak";
    	q.ak = request.License;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("APIKey not found")()
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got APIKey "+ request.License )();
        		response << result.row[i]
      		}
    	};
    	println@Console("Retrieved all info about the specific APIKey")()
  	}]




  	// controlla se l'apikey sia legata ad un utente ed un microservizio esista e sia valida
  	[check_apikey_isactive( request )( response ) {

    	//query
    	q = "SELECT Remaining FROM apikeys WHERE IdClient=:i AND IdMS=:ims AND Remaining > 0";
    	q.i = request.IdClient;
    	q.ims = request.IdMS;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Active APIKey not found")();
      		response = false
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got active APIKey of client " + request.IdClient + " and ms " + request.IdMS )();
        		response = true
      		}
    	};
    	println@Console("Retrieved validity of and APIKey")()
  	}]




  	// recupera le apikey attive a partire dall'id di un utente
  	[retrieve_active_apikey_from_userid( request )( response ) {

  		// query
  		q = "SELECT APIKey,IdMS,IdClient,Remaining FROM apikeys WHERE Remaining > 0 AND IdClient=:i";
  		q.i = request.Id;
  		query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Active APIKeys not found")()
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got APIKey number " + i )();
        		response.apikeyslist[i] << result.row[i]
      		}
    	};
    	println@Console("Retrieved purchases list of the user with id " + request.Id)()

  	}]




  	// recupera il numero di apikey attive a partire dall'id di un utente
  	[retrieve_active_apikey_number_from_msid( request )( response ) {

  		// query
  		q = "SELECT IdMS FROM apikeys WHERE Remaining > 0 AND IdMS=:i";
  		q.i = request.Id;
  		query@Database( q )( result );

    	if ( #result.row == 0 ) {
        println@Console("Active APIKeys not found")();
      	response.IdMS = request.Id;
    		response.Licenses = 0
    	}
    	else {
        println@Console( "Got APIKey number from ms " + result.row[i].IdMS )();
    		response.IdMS = result.row[i].IdMS;
    		response.Licenses = #result.row
      	};
    	println@Console("Retrieved " + response + " of active apikeys")()

  	}]




    // recupera la lista delle transazioni di un utente
    [retrieve_purchases_list_from_userid( request )( response ) {

      // query
      q = "SELECT IdPurchase,APIKey,IdClient,Timestamp,Amount,Type FROM purchases WHERE IdClient=:i";
      q.i = request.Id;
      query@Database( q )( result );

      if ( #result.row == 0 ) {
          println@Console("Purchases not found")()
      }
      else {
          for ( i=0, i<#result.row, i++ ) {
            println@Console( "Got purchase number " + i )();
            response.purchaseslist[i] << result.row[i]
          }
      };
      println@Console("Retrieved purchases list of the user with id " + request.Id)()

    }]




    // recupera la lista dei microservizi con apikey attiva a partire dall'id del client
    [retrieve_mslist_from_clientid( request )( response ) {

      // query
      q = "SELECT IdMS,Remaining FROM apikeys WHERE IdClient=:i AND Remaining > 0";
      q.i = request.Id;
      query@Database( q )( result );

      if ( #result.row == 0 ) {
          println@Console("IdMS not found")()
      }
      else {
          for ( i=0, i<#result.row, i++ ) {
            println@Console( "Got ms number " + i )();
            response.msremaininglist[i] << result.row[i]
          }
      };
      println@Console("Retrieved ms list of the client with id " + request.Id)()

    }]




  	// registra una nuova apikey
  	[apikey_registration( request )( response ) {

    	//genera api key
    	getRandomUUID@StringUtils()( random );
    	_API_45_Y = random;
    	__checkIfAPIKeyUnique;

    	if (_unique_45_Y) {
     		//query
      		q = "INSERT INTO apikeys (IdMS, APIKeym IdClient,Remaining) VALUES (:ims,:apik, :ic,:r)";
      		with( request ) {
        		q.ims = .IdMS;
        		q.apik = random;
        		q.ic = .IdClient;
        		q.r = 50 // hard-coded: da sistemare per implementazione acquisto
      		};
      		update@Database( q )( result );
      		response = true;
      		println@Console( "Registering new apikey for microservice " + request.IdMS + " by client " + request.IdClient )()
    	} 
    	else {
      		response = false
    	}
    
  	}]




  	// registra un nuovo acquisto di una apikey
  	[purchase_registration( request )( response ) {

    	//query
    	q = "INSERT INTO purchases (APIKey,IdClient,Timestamp,Amount,Type) VALUES (:ak,:ic,:t,:a,:ty)";
    	with( request ) {
      		q.ak = .APIKey;
      		q.ic = .IdClient;
      		q.t = .Timestamp;
      		q.a = .Amount;
      		q.ty = .Type
    	};
    	update@Database( q )( result );
    	println@Console( "Registering new purchase with apikey " + request.APIKey + " by client " + request.IdClient )()

  	}]




  	// aggiorna il campo remaining di una apikey (aggiunge o sottrae in base a number)
  	[apikey_remaining_update( request )( response ) {

    	//query
    	q = "UPDATE apikeys SET Remaining=Remaining+:n WHERE APIKey=:i";
    	with( request ) {
      		q.i = .APIKey;
      		q.n = .Number
    	};
    	update@Database( q )( result );
    	println@Console( "Updating remaining of APIKey " + request.APIKey )()

  	}]

}