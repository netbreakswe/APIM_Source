include "transactions_dbInterface.iol"

interface JavaInterface {
	RequestResponse: 
		getA(void)( string ),	
		getB(void)(string),
		getC(void)(string)
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
 Interfaces: JavaInterface
 Location: "socket://localhost:8310"
 Protocol: http
}

inputPort Client {
 Location: "local"
 Interfaces: AggregatorInterface
 Aggregates: SubService0 with AuthInterfaceExtender 
}

 courier Client {
  [ interface JavaInterface( request )( response ) ] {
    check.APIKey = request.key;
    check.IdClient = request.user;
    check_apikey_exists@transactions_dbOutput( check )( validity );    if( validity ) {
      forward ( request )( response )
    }
  }
  [ interface JavaInterface( request ) ] {
    forward ( request )
  }
 }

main {
  mock( r )( rs ) {
    rs = void
  }
}
