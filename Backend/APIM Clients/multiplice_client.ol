include "console.iol"

include "interfaces/Multiplice_112.iol"

main
{

	req1 = 4;
	with( req1 ) {
        .key = "7f6efa6c-621b-425a-a42a-14c6f38348ce";
        .user = "a30ed31c-4960-45fc-b520-03e0d453100f"; // yvette chance
        .api = 112
    };

	req2 = 5;
	with( req2 ) {
        .key = "7f6efa6c-621b-425a-a42a-14c6f38348ce";
        .user = "a30ed31c-4960-45fc-b520-03e0d453100f"; // yvette chance
        .api = 112
    };

	println@Console( "Multiplice: 6*3 and 7*4" )();
	thrice@Multiplice_112( req1 )( response );
	println@Console( response )();
	quadrice@Multiplice_112( req2 )( response );
	println@Console( response )()

}