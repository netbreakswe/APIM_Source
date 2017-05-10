include "interfaces/calc_suminterface.iol"
include "interfaces/calc_subinterface.iol"
include "interfaces/calc_divinterface.iol"



execution { concurrent }

//requester e gateway hanno un'interfaccia in comune
inputPort CalcService {
	Location: "socket://localhost:8076"
	Protocol: http { 
		//Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins.
		.response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
		.response.headers.("Access-Control-Allow-Origin") = "*";
		.response.headers.("Access-Control-Allow-Headers") = "Content-Type"

	}
	Interfaces: SumInterface, SubInterface, DivInterface
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