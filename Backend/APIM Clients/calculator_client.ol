include "interfaces/Calculator_209.iol"
include "console.iol"

main 
{
	with( req1 ) {
		.a = 13;
		.b = 17;

        .key = "d8b14063-c707-4ce1-9347-ad8ca993ea77";
        .user = "b87c580f-eabd-4943-be43-8fbf8be8fadb"; // girolamo crocetti
        .api = 209
    };
    sumanddouble@Calculator_209( req1 )( response );
    println@Console( response )()

}
