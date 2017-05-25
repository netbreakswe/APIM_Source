type op: void {
	.a: int
	.b: int
}

interface DivInterface {
  RequestResponse:
    div( op )( double ),
    divanddouble(op)( double ) 
}

type op: void {
	.a: int
	.b: int
}

interface SubInterface {
  RequestResponse:
    sub( op )( double ),
    subanddouble(op)( double )
}

type op: void {
	.a: int
	.b: int
}

interface SumInterface {
  RequestResponse:
    sum( op )( double ),
    sumanddouble(op)( double )
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
 Interfaces: DivInterface, SubInterface, SumInterface
 Location: "socket://localhost:8076"
 Protocol: http
}

inputPort Client {
 Location: "local"
 Interfaces: AggregatorInterface
 Aggregates: SubService0 with AuthInterfaceExtender 
}

 courier Client {
  [ interface DivInterface( request )( response ) ] {
      forward ( request )( response )
  }
  [ interface SubInterface( request )( response ) ] {
      forward ( request )( response )
  }
  [ interface SumInterface( request )( response ) ] {
      forward ( request )( response )
  }
  [ interface DivInterface( request ) ] {
    forward ( request )
  }
  [ interface SubInterface( request ) ] {
    forward ( request )
  }
  [ interface SumInterface( request ) ] {
    forward ( request )
  }
 }

main {
  mock( r )( rs ) {
    rs = void
  }
}
