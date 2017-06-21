include "powerInterface.iol"
include "powInterface.iol"
include "console.iol"

execution { sequential }

inputPort PowerService {
	Location: "socket://localhost:9005"
	Protocol: sodep
	Interfaces: powerInterface
}

outputPort PowOutput {
	Location: "socket://localhost:9004"
	Protocol: sodep
	Interfaces: powInterface
}

main 
{

	[power( request )( response ) {
		rq.x = request.x;
		rq.y = request.y;
		println@Console( rq.x )();
		println@Console( rq.y )();
		pow@PowOutput( rq )( rs );
		println@Console( rs.result )();
		response = rs.result
	}]

}