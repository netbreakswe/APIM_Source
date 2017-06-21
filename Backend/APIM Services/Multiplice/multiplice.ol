include "MultipliceInterface/multipliceInterface.iol"
include "ThriceInterface/thriceInterface.iol"
include "QUadriceInterface/quadriceInterface.iol"

execution { sequential }

inputPort ThriceService {
	Location: "socket://localhost:9001"
	Protocol: sodep
	Interfaces: ThriceInterface
}

inputPort QuadriceService {
	Location: "socket://localhost:9002"
	Protocol: sodep
	Interfaces: QuadriceInterface
}

inputPort MultipliceService {
	Location: "socket://localhost:9003"
	Protocol: sodep
	Interfaces: MultipliceInterface
}

main
{

	// x3
	[thrice( number )( result ) {
		result = number * 3
	}]

	// x4
	[quadrice( number )( result ) {
		result = number * 4
	}]

}