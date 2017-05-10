include "interfaces/hellointerface.iol"

execution { concurrent }


//requester e gateway hanno un'interfaccia in comune
inputPort HelloService {
	Location: "socket://localhost:9500"
	Protocol: http { 
		//Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins.
		.response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
		.response.headers.("Access-Control-Allow-Origin") = "*";
		.response.headers.("Access-Control-Allow-Headers") = "Content-Type"

	}
	Interfaces: HelloInterface
}


main
{
  [sayhello( request )( response ) {
    response = "hello " + request 
  }]
  [saysuperhello( request )( response ) {
    response = "super hello " + request 
  }]
  [sayagreeting( request )( response ) {
  	if (request > 10) {
    	response = "hi" 
  	} else {
  	    response = "bye" 
  	}
  }]
}