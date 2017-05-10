include "../interfaces/user_db_writerInterface.iol"
include "console.iol"

outputPort user_db_writerOutput {
	Location: "socket://localhost:8202"
	Protocol: sodep
	Interfaces: user_db_writerInterface
}

main
{
	/*
	// insert basic client
	with( basicclientdata ) {
		.Name = "Nicolo";
		.Surname = "Scapin";
		.Email = "ns@libero.it";
		.Password = "40killbattlefield";
		.Avatar = "http:\\motodacorsa.run";
		.Registration = "2017-02-25";
		.Credits = 60
	};
	basicclient_registration@user_db_writerOutput( basicclientdata )( void );
	println@Console("Registered new basic client")()
	*/
	/*
	// upgrade to developer
	with( developerdata ) {
		.IdClient = 3;
		.AboutMe = "Sono Andrea";
		.Citizenship = "Italiano";
		.LinkToSelf = "http://as.com";
		.PayPal = "6666-7777-8888-9999"
	};
  	developer_upgrade@user_db_writerOutput( developerdata )();
  	println@Console("Upgraded basic client with id " + developerdata.IdClient +" to developer status")()
	*/
	/*
	// downgrade to basic client
	downgradedclient.IdClient = 3;
  	basicclient_downgrade@user_db_writerOutput( downgradedclient )();
  	println@Console("Downgraded developer with id " + downgradedclient.IdClient +" to basic client status")()
  	*/
  	/*
  	// insert moderation entry
	with( entrydataw ) {
		.IdClient = 2;
		.IdAdmin = 1;
		.Timestamp = "2017-03-02 12:00:12";
		.ModType = 2;
		.Report = "Servizio instabile"
	};
  	client_moderation@user_db_writerOutput( entrydataw )();
  	println@Console("Created new moderation entry")()
  	*/
  	/*
  	// modify user
  	with( userdata ) {
		.IdClient = 3;
		.Name = "Nicoloo";
		.Surname = "Scapinn";
		.Email = "ns@liber.it";
		.Password = "40killbattlefiel";
		.Avatar = "http:\\motodacorsa.ru";
		.Credits = 70;
		.AboutMe = "ssssss";
		.Citizenship = "bbbb";
		.LinkToSelf = "aaaa";
		.PayPal = "333"
	};
  	client_update@user_db_writerOutput( userdata )();
  	println@Console("Modified user profile with id " + userdata.IdClient)()
  	*/
  	/*
	// delete client
	with( clientid ) {
		.Id = 3
	};
  	client_delete@user_db_writerOutput( clientid )();
  	println@Console("Deleted client with id " + clientid.Id)()
  	*/
}