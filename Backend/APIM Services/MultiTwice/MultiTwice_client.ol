include "console.iol"

include "interfaces/MultiTwiceInterface.iol"

outputPort MultiTwiceService {
	Location: "socket://localhost:9006"
	Protocol: sodep
	Interfaces: MultiTwiceInterface
}

main
{

	println@Console( "MultiTwice: 4*2 and 5*3 and 6*4" )();

	req1 = 4;
	with( req1 ) {
        .keytwice = "459cd59f-4706-4d8f-b855-61d4f836984d";
        .usertwice = "e6bfd0ae-53be-4922-94c7-011e4b155ee0"; // girolamo crocetti
        .apitwice = 109
    };
    twice_APIcall@MultiTwiceService( req1 )( response );
    println@Console( response )();

	thrice@MultiTwiceService( 5 )( response );
	println@Console( response )();

	quadrice@MultiTwiceService( 6 )( response );
	println@Console( response )()

}