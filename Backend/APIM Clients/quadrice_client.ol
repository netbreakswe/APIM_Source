include "console.iol"

include "interfaces/Quadrice_111.iol"

main
{

	req1 = 5;
	with( req1 ) {
        .key = "f7bda6cd-079b-4788-b07e-1c4b2f26a3d2";
        .user = "a30ed31c-4960-45fc-b520-03e0d453100f"; // yvette chance
        .api = 111
    };

	println@Console( "Quadrice: 5*4" )();
	quadrice@Quadrice_111( req1 )( response );
	println@Console( response )()

}