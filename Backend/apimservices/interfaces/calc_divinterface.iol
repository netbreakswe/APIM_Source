type op: void {
	.a: int
	.b: int
}

interface DivInterface {
  RequestResponse:
    div( op )( double ),
    divanddouble(op)( double ) 
}