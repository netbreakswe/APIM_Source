include "console.iol"

include "interfaces/Thrice_110.iol"

main
{

	req1 = 4;
	with( req1 ) {
        .key = "740cf9b2-cb43-44fe-983e-39ac3a19f278";
        .user = "a30ed31c-4960-45fc-b520-03e0d453100f"; // yvette chance
        .api = 110
    };

	println@Console( "Thrice: 4*3" )();
	thrice@Thrice_110( req1 )( response );
	println@Console( response )()

}