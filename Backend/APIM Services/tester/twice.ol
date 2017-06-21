include "twiceInterface.iol"

execution { sequential }

inputPort TwiceService {
	Location: "socket://localhost:9000"
	Protocol: sodep
	Interfaces: TwiceInterface
}

main
{
	twice( number )( result )
	{
		result = number * 2
	}
}