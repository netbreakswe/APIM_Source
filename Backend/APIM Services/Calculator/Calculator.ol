include "interfaces/CalculatorInterface.iol"

execution { concurrent }

inputPort CalculatorService {
	Location: "socket://localhost:9007"
	Protocol: sodep
	Interfaces: CalculatorInterface
}


main
{

  [sum( request )( response ) {
    response = request.a + request.b
  }]

  [sumanddouble( request )( response ) {
    response = (request.a + request.b)*2
  }]

  [sub( request )( response ) {
    response = request.a - request.b
  }]

  [subanddouble( request )( response ) {
    response = (request.a - request.b)*2
  }]

  [div( request )( response ) {
    response = request.a/request.b
  }]

  [divanddouble( request )( response ) {
    response = (request.a/request.b)*2
  }]

}