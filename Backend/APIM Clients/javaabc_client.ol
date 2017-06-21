include "interfaces/JavaABC_211.iol"
include "console.iol"

main 
{
	with( req1 ) {
        .key = "efb40821-5dd8-43cf-8c72-daf2c1460153";
        .user = "e0679c2a-90dd-49a4-9152-436d752fdbaf"; // jolanda geelen
        .api = 211
    };
    getA@JavaABC_211( req1 )( response );
    println@Console( response )()

}
