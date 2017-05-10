type op: void {
	.a: int
	.b: int
}

interface SubInterface {
  RequestResponse:
    sub( op )( double ),
    subanddouble(op)( double )
}