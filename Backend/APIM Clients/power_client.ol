include "console.iol"

include "interfaces/Power_203.iol"

main
{

	req1.x = 4.0;
	req1.y = 5.0;
	with( req1 ) {
        .key = "65e18acc-22dc-4f30-96a9-e1889731ab64";
        .user = "a30ed31c-4960-45fc-b520-03e0d453100f"; // yvette chance
        .api = 203
    };
	power@Power_203( req1 )( response );
	println@Console( response )()

}