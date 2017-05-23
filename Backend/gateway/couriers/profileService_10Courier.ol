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
       forward ( request )( response )
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
