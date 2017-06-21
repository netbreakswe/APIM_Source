include "console.iol"
include "powerInterface.iol"

outputPort PowerService {
	Location: "socket://localhost:9005"
	Protocol: sodep
	Interfaces: powerInterface
}

main
{
	request.x = 7.0;
	request.y = 7.0;
	power@PowerService( request )( response );
	println@Console( response )()
}