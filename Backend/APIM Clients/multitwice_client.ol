include "console.iol"

include "interfaces/MultiTwice_207.iol"

main
{

	println@Console( "MultiTwice: 4*2 and 5*3 and 6*4" )();

	req1 = 4;
	with( req1 ) {
		.key = "8e7045ce-ff32-45b4-815c-4d6dbcde843c";
        .user = "e6bfd0ae-53be-4922-94c7-011e4b155ee0"; // girolamo crocetti
        .api = 207;

        .keytwice = "459cd59f-4706-4d8f-b855-61d4f836984d";
        .usertwice = "e6bfd0ae-53be-4922-94c7-011e4b155ee0"; // girolamo crocetti
        .apitwice = 109
    };

    twice_APIcall@MultiTwice_207( req1 )( response );
    println@Console( response )();

    req2 = 5;
	with( req2 ) {
        .key = "8e7045ce-ff32-45b4-815c-4d6dbcde843c";
        .user = "e6bfd0ae-53be-4922-94c7-011e4b155ee0"; // girolamo crocetti
        .api = 207
    };

	thrice@MultiTwice_207( req2 )( response );
	println@Console( response )();

	req3 = 6;
	with( req3 ) {
        .key = "8e7045ce-ff32-45b4-815c-4d6dbcde843c";
        .user = "e6bfd0ae-53be-4922-94c7-011e4b155ee0"; // girolamo crocetti
        .api = 207
    };

	quadrice@MultiTwice_207( req3 )( response );
	println@Console( response )()

}