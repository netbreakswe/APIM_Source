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
      forward ( request )( response )
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
