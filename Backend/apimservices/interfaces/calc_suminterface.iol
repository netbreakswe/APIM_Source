type op: void {
	.a: int
	.b: int
}

interface SumInterface {
  RequestResponse:
    sum( op )( double ),
    sumanddouble(op)( double )
}