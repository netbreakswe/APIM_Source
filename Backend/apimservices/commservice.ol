include "interfaces/faxinterface.iol"
include "interfaces/mailinterface.iol"
include "console.iol"

execution { concurrent }

inputPort CommService {
	Location: "socket://localhost:9202"
	Protocol: sodep
	Interfaces: FaxInterface, MailInterface
}

main
{
	[fax( request )(response) {
	     response = "Faxing to " + request.destination + "\n. Content: " + request.content + "\n ok fax mandato" 
	}]
	[faxwithnoresponse( request )] {
	     println@Console("Faxing to " + request.destination + "\n. Content: " + request.content + "\n")()
	}
	[mail( request )(response) {
	     response = "Mailing to " + request.mail + "\n. Content: " + request.content + "\n ok mail mandata" 
	}]
	[mailwithnoresponse( request )] {
	     println@Console("Mailing to " + request.mail + "\n. Content: " + request.content + "\n")()
	}
}
