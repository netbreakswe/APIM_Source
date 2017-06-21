include "powjavaInterface.iol"
include "powInterface.iol"
include "console.iol"

execution { sequential }

inputPort PowService {
	Location: "socket://localhost:9004"
	Protocol: sodep
	Interfaces: powInterface
}

outputPort powjavaOutput {
	Interfaces: powjavaInterface
}

embedded {
	Java: "jolie.pow.pow" in powjavaOutput
}

main 
{

	[pow( request )( response ) {
		rq.x = request.x;
		rq.y = request.y;
		println@Console( rq.x )();
		println@Console( rq.y )();
		pow@powjavaOutput( rq )( rs );
		println@Console( rs.result )();
		response.result = rs.result
	}]

}