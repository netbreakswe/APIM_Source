include "console.iol"
include "MailerInterface.iol"

outputPort MailerService {
	Location: "socket://localhost:9004"
	Protocol: sodep
	Interfaces: MailerInterface
}

main
{
	println@Console( "Sending mail to: " )();
	mail@MailerService( "Aaa" )( response );
	println@Console( response )()
}