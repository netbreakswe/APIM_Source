include "interfaces/javainterface.iol"

execution { concurrent }


outputPort JavaExecutable {
	Interfaces: JavaInterface
}

inputPort JolieporttoClient {
	Location: "socket://localhost:9004"
	Protocol: sodep
	Interfaces: JavaInterface
}

embedded {
	Java: "test.Jolietest" in JavaExecutable
}

main
{
	[getA( request )( result ) {
		getA@JavaExecutable(request)(result)
	}]
	[getB( request )( result ) {
		getB@JavaExecutable(request)(result)
	}]
	[getC( request )( result ) {
		getC@JavaExecutable(request)(result)
	}]


}