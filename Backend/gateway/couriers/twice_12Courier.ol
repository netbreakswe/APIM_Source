interface TwiceInterface { 
	RequestResponse: twice( int )( int ) 
}



execution { concurrent }

type AuthenticationData: any {
 .key: string
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
 Interfaces: TwiceInterface
 Location: "socket://localhost:9000"
 Protocol: sodep
}

inputPort Client {
 Location: "local"
 Interfaces: AggregatorInterface
 Aggregates: SubService0 with AuthInterfaceExtender 
}

 courier Client {
    [ interface TwiceInterface( request )( response ) ] {
       forward ( request )( response )
    }
    [ interface TwiceInterface( request ) ] {
       forward ( request )
    }
 }

main {
 mock( r )( rs ) {
    rs = void
 }
}
