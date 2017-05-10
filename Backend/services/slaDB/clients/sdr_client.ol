include "../interfaces/sla_db_readerInterface.iol"
include "console.iol"

outputPort sla_db_readerOutput {
  Location: "socket://localhost:8211"
	Protocol: sodep
	Interfaces: sla_db_readerInterface
}

main
{
  /*
	// specific api key sla survey lister
  apikeyid.Id = 2;
  println@Console("Getting sla survey complete list about a specific API key")();
  retrieve_apikey_slasurvey_list@sla_db_readerOutput( apikeyid )( response );
  
  for( i=0, i<#response.SlaSurveyListData, i++ ) {
    with ( response.SlaSurveyListData[i] ) {
      println@Console( .IdMS )();
      println@Console( .Timestamp )();
      println@Console( .ResponseTime )();
      println@Console( .IsCompliant )()
    }
  }
  */
  /*
  // specific microservice sla survey lister
  msid.Id = 2;
  println@Console("Getting sla survey complete list about a specific microservice")();
  retrieve_ms_slasurvey_list@sla_db_readerOutput( msid )( response );
  
  for( i=0, i<#response.SlaSurveyListMSData, i++ ) {
    with ( response.SlaSurveyListMSData[i] ) {
      println@Console( .Timestamp )();
      println@Console( .ResponseTime )();
      println@Console( .IsCompliant )()
    }
  }
  */
  /*
	// sla survey info getter
	slasurveyid.Id = 1;
	println@Console("Getting sla survey info... about " + slasurveyid.Id)();
	retrieve_slasurvey_info@sla_db_readerOutput( slasurveyid )( response );
	
	for( i=0, i<#response.SlaSurveyData, i++ ) {
		with ( response.SlaSurveyData[i] ) {
			println@Console( .IdSLASurvey )();
      println@Console( .IdMS )();
			println@Console( .Timestamp )();
			println@Console( .ResponseTime )();
			println@Console( .IsCompliant )()
    }
  }
  */
  /*
  // sla survey iscompliant getter
  slasurveyid.Id = 1;
  println@Console("Getting sla survey iscompliant... about " + slasurveyid.Id)();
  retrieve_slasurvey_iscompliant@sla_db_readerOutput( slasurveyid )( response );
	for( i=0, i<#response.IsCompliantData, i++ ) {
		with ( response.IsCompliantData[i] ) {
			println@Console( .IsCompliant )()
    }
  }
  */
}