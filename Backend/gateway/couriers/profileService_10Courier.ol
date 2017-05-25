include "transactions_dbInterface.iol"

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
    check.APIKey = request.key;
    check.IdClient = request.user;
    check_apikey_exists@transactions_dbOutput( check )( validity );    if( validity ) {
      forward ( request )( response )
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
