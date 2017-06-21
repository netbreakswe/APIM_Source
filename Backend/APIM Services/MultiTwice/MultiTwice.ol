include "interfaces/MultiTwiceInterface.iol"
include "interfaces/Twice_109.iol"

include "console.iol"

execution { sequential }

inputPort MultiTwiceService {
	Location: "socket://localhost:9006"
	Protocol: sodep
	Interfaces: MultiTwiceInterface
}

main
{
	// x2
	[twice_APIcall( twicerequest )( result ) {
		req1 = twicerequest;
		println@Console( req1 )();
		with( req1 ) {
        	.key = twicerequest.keytwice;
        	.user = twicerequest.usertwice;
        	.api = twicerequest.apitwice
    	};
    	println@Console( "keytwice"+twicerequest.keytwice )();
    	println@Console( twicerequest.usertwice )();
    	println@Console( twicerequest.apitwice )();
    	println@Console( "reqkey"+req1.key )();
    	println@Console( req1.user )();
    	println@Console( req1.api )();
		twice@Twice_109( req1 )( response );
		result = response
	}]

	// x3
	[thrice( number )( result ) {
		result = number * 3
	}]

	// x4
	[quadrice( number )( result ) {
		result = number * 4
	}]

}