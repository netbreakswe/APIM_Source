include "interfaces/Twice_109.iol"
include "console.iol"

main 
{
	req1 = 5;
	with( req1 ) {
        .key = "459cd59f-4706-4d8f-b855-61d4f836984d";
        .user = "e6bfd0ae-53be-4922-94c7-011e4b155ee0"; // girolamo crocetti
        .api = 109
    };
    twice@Twice_109( req1 )( response );
    println@Console( response )()

}
