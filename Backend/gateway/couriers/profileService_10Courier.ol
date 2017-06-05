include "transactions_dbInterface.iol"
include "sla_dbInterface.iol"

type persone: void {
	.persona[0, *]: void {
		.nome:string
		.cognome:string
	}
}


type nomecognome:void {
	.nome:string
	.cognome:string
}


interface ProfileInterface { 
	RequestResponse: 
	getUsers( void )( persone ),	
	insertUser(nomecognome)(void)
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
    mock(string)(string)
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

outputPort SubService0 {
 Interfaces: ProfileInterface
 Location: "socket://localhost:8030"
 Protocol: http
}

inputPort Client {
 Location: "local"
 Interfaces: AggregatorInterface
 Aggregates: SubService0 with AuthInterfaceExtender 
}

 courier Client {
  [ interface ProfileInterface( request )( response ) ] {
    requestinfo.APIKey = request.key;
    requestinfo.IdClient = request.user;
    requestinfo.IdMS = request.api;
    check.APIKey = requestinfo.APIKey;
    check.IdClient = requestinfo.IdClient;
    check.IdMS = requestinfo.IdMS;
    check_apikey_exists@transactions_dbOutput( check )( validity );
    if( validity ) {
      forward ( request )( response );
      slasurvey.APIKey = requestinfo.APIKey;
      slasurvey.IdMS = requestinfo.IdMS;
      slasurvey.Timestamp = "2017-06-05 12:11:10";
      slasurvey.ResponseTime = 10;
      slasurvey.IsCompliant = true;
	   slasurvey_insert@sla_dbOutput( slasurvey )( void )
    }
  }
  [ interface ProfileInterface( request ) ] {
    forward ( request )
  }
 }

main {
  mock( r )( rs ) {
    rs = void
  }
}
