type Request:void {
	.destination:string
	.content:string
}

interface FaxInterface {
	OneWay:
		faxwithnoresponse( Request ) 
	RequestResponse:
		fax(Request)( string )
}


type mailreq:void {
	.mail:string
	.content:string
}

interface MailInterface {
	OneWay:
		mailwithnoresponse( mailreq ) 
	RequestResponse:
		mail(mailreq)( string )
}

interface HelloInterface {
  RequestResponse:
    sayhello( string )( string ),
    saysuperhello(string)(string),
    sayagreeting(int)(string)
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
 Interfaces: FaxInterface, MailInterface
 Location: "socket://localhost:9202"
 Protocol: sodep
}

outputPort SubService1 {
 Interfaces: HelloInterface
 Location: "socket://localhost:9500"
 Protocol: http
}

inputPort Client {
 Location: "local"
 Interfaces: AggregatorInterface
 Aggregates: SubService0 with AuthInterfaceExtender, SubService1 with AuthInterfaceExtender 
}

 courier Client {
  [ interface FaxInterface( request )( response ) ] {
      forward ( request )( response )
  }
  [ interface MailInterface( request )( response ) ] {
      forward ( request )( response )
  }
  [ interface HelloInterface( request )( response ) ] {
      forward ( request )( response )
  }
  [ interface FaxInterface( request ) ] {
    forward ( request )
  }
  [ interface MailInterface( request ) ] {
    forward ( request )
  }
  [ interface HelloInterface( request ) ] {
    forward ( request )
  }
 }

main {
  mock( r )( rs ) {
    rs = void
  }
}
