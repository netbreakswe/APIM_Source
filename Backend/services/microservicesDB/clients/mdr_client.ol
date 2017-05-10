include "../interfaces/microservices_db_readerInterface.iol"
include "console.iol"

outputPort microservices_db_readerOutput {
	Location: "socket://localhost:8221"
	Protocol: sodep
	Interfaces: microservices_db_readerInterface
}

main
{
  /*
	// microservice info getter
  msid.Id = 1;
  println@Console("Getting microservice info")();
  retrieve_ms_info@microservices_db_readerOutput( msid )( response );
  
  for( i=0, i<#response.MSData, i++ ) {
    with ( response.MSData[i] ) {
      println@Console( .IdMS )();
      println@Console( .Name )();
      println@Console( .Description )();
      println@Console( .Version )();
      println@Console( .LastUpdate )();
      println@Console( .IdDeveloper )();
      println@Console( .Logo )();
      println@Console( .DocPDF )();
      println@Console( .DocExternal )();
      println@Console( .Profit )();
      println@Console( .IsActive )();
      println@Console( .SLAGuaranteed )();
      println@Console( .Policy )()
    }
  }
  */
  /*
	// interface info getter
	intfid.Id = 1;
	println@Console("Getting interface info... about " + intfid.Id)();
	retrieve_intf_info@microservices_db_readerOutput( intfid )( response );
	
	for( i=0, i<#response.IntfData, i++ ) {
		with ( response.IntfData[i] ) {
			println@Console( .Interf )();
      println@Console( .Loc )();
			println@Console( .Protoc )()
    }
  }
  */
  /*
  // interfaces id of a specific microservice getter
  msid.Id = 1;
  println@Console("Getting interfaces id list of a specific microservice")();
  retrieve_interfaces_of_ms@microservices_db_readerOutput( msid )( response );
  
  for( i=0, i<#response.IntfIdListData, i++ ) {
    with ( response.IntfIdListData[i] ) {
      println@Console( .IdInterface )()
    }
  }
  */
  /*
  // microservice id from specific interface getter
  intfid.Id = 2;
  println@Console("Getting microservice id from interface " + intfid.Id)();
  retrieve_ms_from_interface@microservices_db_readerOutput( intfid )( response );
	for( i=0, i<#response.MSIdData, i++ ) {
		with ( response.MSIdData[i] ) {
			println@Console( .IdMS )()
    }
  }
  */
  /*
  // category info getter
  categoryid.Id = 1;
  println@Console("Getting category info... about " + categoryid.Id)();
  retrieve_category_info@microservices_db_readerOutput( categoryid )( response );
  
  for( i=0, i<#response.CategoryData, i++ ) {
    with ( response.CategoryData[i] ) {
      println@Console( .Name )();
      println@Console( .Image )()
    }
  }
  */
  /*
  // categories id of a specific microservice getter
  msid.Id = 1;
  println@Console("Getting categories id list of a specific microservice")();
  retrieve_categories_of_ms@microservices_db_readerOutput( msid )( response );
  
  for( i=0, i<#response.CategoryIdListData, i++ ) {
    with ( response.CategoryIdListData[i] ) {
      println@Console( .IdCategory )()
    }
  }
  */
  /*
  // last registered microservice lister
  shownumber.number = 4;
  println@Console("Getting last registered microservices")();
  retrieve_last_registered_ms@microservices_db_readerOutput( shownumber )( response );
  
  for( i=0, i<#response.MSRegListData, i++ ) {
    with ( response.MSRegListData[i] ) {
      println@Console( .Name )();
      println@Console( .Logo )()
    }
  }
  */
}