include "mailerInterface.iol"
include "console.iol"
include "smtp.iol"

execution { sequential }

inputPort MailerService {
	Location: "socket://localhost:9004"
	Protocol: sodep
	Interfaces: MailerInterface
}

main
{
	mail( request )( response ) {

		with(maildata) {

			.authenticate.username = "kutinjiu";
			.authenticate.password = "ragnarok93";
		 	.content = "Ciao ecco la tua password:";
		    .to = "kutinju@libero.it";
		    .subject = "Password Recovery";
		    .host = "smtp.gmail.com";
		    .from = "kutinjiu@gmail.com"

		};
		sendMail@SMTP( maildata )();

		response = "Sent mail to"
	}
}