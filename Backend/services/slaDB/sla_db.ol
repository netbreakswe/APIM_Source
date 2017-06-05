include "interfaces/sla_dbInterface.iol"

include "database.iol"
include "console.iol"

execution { sequential }

// basta questa port per comunicare con tutti i servizi
inputPort sla_dbJSONInput {
  Location: "socket://localhost:8141"
  Protocol: http { 
    // Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins
    .response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
    .response.headers.("Access-Control-Allow-Origin") = "*";
    .response.headers.("Access-Control-Allow-Headers") = "Content-Type, Authorization";
    .format = "json"
  }
  Interfaces: sla_dbInterface
}

init
{

	println@Console( "Sla Db Mcroservice started" )();

  // connect to sla database (heroku)
  with( connectionInfo ) {
      .host = "jfrpocyduwfg38kq.chr7pe7iynqr.eu-west-1.rds.amazonaws.com"; 
      .driver = "mysql";
      .port = 3306;
      .database = "y6hff5aalbvj7wmb";
      .username = "t5vzs8u8j31t0l9m";
      .password = "o0z3fvfoha8e7dqe"
    };
    connect@Database( connectionInfo )();
    println@Console("DB connected, connection is running on host:" + connectionInfo.host )()

}

main
{


  [retrieve_apikey_slasurvey_list( request )( response ) {

    //query
    q = "SELECT Timestamp,IdMS,ResponseTime,IsCompliant FROM slasurveys WHERE IdAPIKey=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if( #result.row == 0 ) {
      println@Console("Sla surveys not found")()
    }
    else {
      for( i=0, i<#result.row, i++ ) {
        println@Console( "Got sla survey number "+ i )();
        response.SlaSurveyListData[i] << result.row[i]
      }
    };
    println@Console("Retrieved sla survey complete list about the specific API key " + request.Id)()

  }]





  [retrieve_ms_slasurvey_list( request )( response ) {

    //query
    q = "SELECT Timestamp,ResponseTime,IsCompliant FROM slasurveys WHERE IdMS=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if( #result.row == 0 ) {
      println@Console("Sla surveys not found")()
    }
    else {
      for( i=0, i<#result.row, i++ ) {
        println@Console( "Got sla survey number "+ i )();
        response.SlaSurveyListMSData[i] << result.row[i]
      }
    };
    println@Console("Retrieved sla survey complete list about the specific microservice " + request.Id)()

  }]





  [retrieve_slasurvey_info( request )( response ) {

    //query
    q = "SELECT IdSLASurvey,IdMS,Timestamp,ResponseTime,IsCompliant FROM slasurveys WHERE IdSLASurvey=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if( #result.row == 0 ) {
      println@Console("Sla survey not found")()
    }
    else {
      for( i=0, i<#result.row, i++ ) {
        println@Console( "Got sla survey "+ result.row[i].IdSLASurvey )();
        response.SlaSurveyData[i] << result.row[i]
      }
    };
    println@Console("Retrieved info about sla survey " + response.SlaSurveyData.IdSLASurvey)()

  }]





  [retrieve_slasurvey_iscompliant( request )( response ) {

    //query
    q = "SELECT IsCompliant FROM slasurveys WHERE IdSLASurvey=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if( #result.row == 0 ) {
      println@Console("Sla survey not found")()
    }
    else {
      for( i=0, i<#result.row, i++ ) {
        println@Console( "Got IsCompliant with result "+ result.row[i].IsCompliant )();
        response.IsCompliantData[i] << result.row[i]
      }
    };
    println@Console("Retrieved IsCompliant with result " + response.IsCompliantData.IsCompliant + " from sla survey " + request.Id)()

  }]





  //inserisci info di sla
  [slasurvey_insert( request )( response ) {

    //query
    q = "INSERT INTO slasurveys (APIKey,IdMS,Timestamp,ResponseTime,IsCompliant) 
      VALUES (:ak,:ims,:ts,:rt,:ic)";
    with( request ) {
      q.ak = .APIKey;
      q.ims = .IdMS;
      q.ts = .Timestamp;
      q.rt = .ResponseTime;
      q.ic = .IsCompliant
    };
    update@Database( q )( result );
    println@Console("Inserting new sla survey about microservice " + request.IdMS )()

  }]


}