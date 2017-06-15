include "transactions_path.ol"
include "sla_path.ol"
include "microservices_path.ol"

include "time.iol"
include "console.iol"

include "calcMessage_path.ol"

interface MultiplicePlusInterface { 
	RequestResponse: 
		thrice( int )( int ),
		quadrice( int )( int )
}

type AuthenticationData: any {
 .key: string
 .user: string
 .api: int
}

interface extender AuthInterfaceExtender {
  RequestResponse:
    *( AuthenticationData )( void )
  OneWay:
    *( AuthenticationData )
}

interface AggregatorInterface {
  RequestResponse:
    mock( string )( string )
}

outputPort transactions_dbOutput {
 Location: "socket://localhost:8131"
 Protocol: http
 Interfaces: transactions_dbInterface
}

outputPort sla_dbOutput {
 Location: "socket://localhost:8141"
 Protocol: http
 Interfaces: sla_dbInterface
}

outputPort microservices_dbOutput {
 Location: "socket://localhost:8121"
 Protocol: http
 Interfaces: microservices_dbInterface
}

outputPort calcMessageOutput {
 Interfaces: calcMessageInterface
}

embedded {
 Java: "jolie.calcMessage.calcMessage" in calcMessageOutput
}

outputPort SubService0 {
 Interfaces: MultiplicePlusInterface
 Location: "socket://localhost:9007"
 Protocol: sodep
}

inputPort Client {
 Location: "local"
 Interfaces: AggregatorInterface
 Aggregates: SubService0 with AuthInterfaceExtender 
}

 courier Client {
  [ interface MultiplicePlusInterface( request )( response ) ] {
    install( RequestNotValid =>
    	println@Console( "Request not valid!" )()
    );    requestinfo.APIKey = request.key;
    requestinfo.IdClient = request.user;
    requestinfo.IdMS = request.api;
    check.APIKey = requestinfo.APIKey;
    check.IdClient = requestinfo.IdClient;
    check.IdMS = requestinfo.IdMS;
    check_apikey_exists@transactions_dbOutput( check )( validity );
    checkisactive.Id = requestinfo.IdMS;
    check_ms_isactive@microservices_dbOutput( checkisactive )( availability );
    if( validity && availability ) {
      slasurvey.APIKey = requestinfo.APIKey;
      slasurvey.IdMS = requestinfo.IdMS;
      getCurrentTimeMillis@Time( void )( currmillis );
      slasurvey.Timestamp = currmillis;
      forward( request )( response );
      getCurrentTimeMillis@Time( void )( responsemillis );
      responsetime = responsemillis - currmillis;
      slasurvey.ResponseTime = responsetime;
      callcompliance.IdMS = requestinfo.IdMS;
      callcompliance.Number = responsetime;
      check_ms_iscompliant@microservices_dbOutput( callcompliance )( compliance );
      slasurvey.IsCompliant = compliance;
      if( compliance ) {
        callidms.Id = requestinfo.IdMS;
        retrieve_ms_policy@microservices_dbOutput( callidms )( policy );
        remaininginfo.APIKey = requestinfo.APIKey;
        if( policy == 1 ) {
          remaininginfo.Number = -1
        }
        else if( policy == 2 ) {
          remaininginfo.Number = 0 - responsetime;
          if(remaininginfo.Number == 0) {
            remaininginfo.Number = -1
          }
        }
        else if( policy == 3 ) {
          calcMessage@calcMessageOutput( request )( reqtraffic );
          calcMessage@calcMessageOutput( response )( resptraffic );
          println@Console( "Reqtraffic: " + reqtraffic.bytesize )(); 
          println@Console( "Resptraffic: " + resptraffic.bytesize )(); 
          remaininginfo.Number = 0 - (reqtraffic.bytesize + resptraffic.bytesize) 
        };
        apikey_remaining_update@transactions_dbOutput( remaininginfo )( void )
      };
	   slasurvey_insert@sla_dbOutput( slasurvey )( void )
    }
    else {
      throw( RequestNotValid )
    }
  }
  [ interface MultiplicePlusInterface( request ) ] {
    forward ( request )
  }
 }

main {
  mock( r )( rs ) {
    rs = void
  }
}
