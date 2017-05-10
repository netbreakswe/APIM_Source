include "../interfaces/user_db_readerInterface.iol"
include "console.iol"

outputPort user_db_readerOutput {
	Location: "socket://localhost:8201"
	Protocol: sodep
	Interfaces: user_db_readerInterface
}

main
{
	/*
	// admin info getter
	adminid.Id = 1;
	println@Console("Getting admin info... about " + adminid.Id)();
	retrieve_admin_info@user_db_readerOutput( adminid )( response );
	
	for( i=0, i<#response.AdminData, i++ ) {
		with ( response.AdminData[i] ) {
			println@Console( .IdAdmin )();
			println@Console( .Name )();
			println@Console( .Surname )();
			println@Console( .Email )();
			println@Console( .Password )()
    }
  }
  */
  /*
  // client info getter
  clientid.Id = 2;
  println@Console("Getting client info... about " + clientid.Id)();
  retrieve_client_info@user_db_readerOutput( clientid )( response );
	for( i=0, i<#response.ClientData, i++ ) {
		with ( response.ClientData[i] ) {
			println@Console( .IdClient )();
			println@Console( .Name )();
			println@Console( .Surname )();
			println@Console( .Email )();
			println@Console( .Password )();
			println@Console( .Avatar )();
      println@Console( .Credits )()
    }
  }
  */
  /*
  // client fullname getter
  clientid.Id = 2;
  println@Console("Getting client fullname... about " + clientid.Id)();
  retrieve_client_fullname@user_db_readerOutput( clientid )( response );
  for( i=0, i<#response, i++ ) {
    with ( response ) {
      println@Console( .Name )();
      println@Console( .Surname )()
    }
  }
  */
  /*
  // client type checker
  clientid.Id = 1;
  retrieve_client_type@user_db_readerOutput( clientid )( response );
  println@Console("Client type is " + response.ClientType)()
	*/
	/*
	// modentry info getter
  modentryid.Id = 2;
  retrieve_moderation_info@user_db_readerOutput( modentryid )( response );
  for( i=0, i<#response.EntryData, i++ ) {
  	with ( response.EntryData[i] ) {
  		println@Console( .IdEntry )();
  		println@Console( .IdClient )();
      println@Console( .IdAdmin )();
      println@Console( .Timestamp )();
      println@Console( .ModType )();
      println@Console( .Report )()
    }
	}
	*/
	/*
	// modtype info getter
	modtypeid.Id = 1;
  retrieve_modtype_info@user_db_readerOutput( modtypeid )( response );
  for( i=0, i<#response.ModTypeData, i++ ) {
  		with ( response.ModTypeData[i] ) {
  			println@Console( .IdModType )();
  			println@Console( .Name )();
        println@Console( .Description )()
    }
	}
	*/
	/*
	// clienttype info getter
	clienttypeid.Id = 2;
  retrieve_clienttype_info@user_db_readerOutput( clienttypeid )( response );
  for( i=0, i<#response.ClientTypeData, i++ ) {
  	with ( response.ClientTypeData[i] ) {
  		println@Console( .IdClientType )();
  		println@Console( .Name )();
      println@Console( .Description )()
    }
	}
	*/
}