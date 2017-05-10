include "interfaces/transactions_dbInterface.iol"

include "database.iol"
include "console.iol"
include "string_utils.iol"


execution { sequential }

/*basta questa port per comunicare con tutti i servizi*/
inputPort transactions_dbJSONInput {
  Location: "socket://localhost:8131"
  Protocol: http { 
    //Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins
    .response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
    .response.headers.("Access-Control-Allow-Origin") = "*";
    .response.headers.("Access-Control-Allow-Headers") = "Content-Type, Authentication";
    .format = "json"
    }
  Interfaces: transactions_dbInterface
}

/*1. procedura che verifica se l'api key generata e' univoca */
define __checkIfAPIKeyUnique {
  q_45_Y = "select * from apikeys where APIKey = :api";
  q_45_Y.api = _API_45_Y;
  query@Database( q_45_Y )( result_45_Y );
  if (#result_45_Y.row == 0) {
    _unique_45_Y = true;
  } else {
    _unique_45_Y = false;
  }
}





init
{
	println@Console( "Transactions Db Microservice started" )();

  //connect to transactions database (heroku)
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


  /*controlla esistenza apikey*/
  [apikey_exists( request )( response ) {
    _API_45_Y = random;
    __checkIfAPIKeyUnique;
     if (_unique_45_Y) {
      response = true;
      println@Console( "Exists" )()
    } else {
      response = false;
      println@Console( "Not Exists")()
    }
  }]




  
  [retrieve_apikey_info( request )( response ) {

    //query
    q = "SELECT IdMS,IdClient,Remaining FROM apikeys WHERE IdAPIKey=:iak";
    q.iak = request.Id;
    query@Database( q )( result );

    if ( #result.row == 0 ) {
      println@Console("APIKey not found")()
    }
    else {
      for ( i=0, i<#result.row, i++ ) {
        println@Console( "Got APIKey with id "+ request.Id )();
        response.APIKeyData[i] << result.row[i]
      }
    };
    println@Console("Retrieved all info about the specific APIKey")()
  }]








  [retrieve_purchases_list( request )( response ) {

    //query
    q = "SELECT IdPurchase,Timestamp,Price,Amount FROM purchases WHERE IdClient=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if ( #result.row == 0 ) {
      println@Console("Purchase not found")()
    }
    else {
      for ( i=0, i<#result.row, i++ ) {
        println@Console( "Got purchase number " + i )();
        response.PurchasesListData[i] << result.row[i]
      }
    };
    println@Console("Retrieved purchases of the client with id " + request.Id)()
  }]








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
        q.r = 50 //hard-coded: da sistemare per implementazione acquisto
      };
      update@Database( q )( result );
      response = true;
      println@Console( "Registering new apikey for microservice " + request.IdMS + " by client " + request.IdClient )()
    } else {
      response = false;
    }
    
  }]










  [purchase_registration( request )( response ) {

    //query
    q = "INSERT INTO purchases (IdAPIKey,IdClient,Timestamp,Price,Amount) VALUES (:iak,:ic,:t,:p,:a)";
    with( request ) {
      q.iak = .IdAPIKey;
      q.ic = .IdClient;
      q.t = .Timestamp;
      q.p = .Price;
      q.a = .Amount
    };
    update@Database( q )( result );
    println@Console( "Registering new purchase with apikey " + request.IdAPIKey + " by client " + request.IdClient )()
  }]











  [apikey_remaining_update( request )( response ) {

    //query
    q = "UPDATE apikeys SET Remaining=Remaining-:n WHERE IdAPIKey=:i";
    with( request ) {
      q.i = .IdAPIKey;
      q.n = .Number
    };
    update@Database( q )( result );
    println@Console( "Updating remaining of APIKey " + request.IdAPIKey )()
  }]

}