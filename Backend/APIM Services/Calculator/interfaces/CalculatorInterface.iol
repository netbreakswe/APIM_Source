type op: void {
	.a: int
	.b: int
}

interface CalculatorInterface {
  RequestResponse:
    sum( op )( double ),
    sumanddouble( op )( double ),
    sub( op )( double ),
    subanddouble( op )( double ),
    div( op )( double ),
    divanddouble( op )( double )
}