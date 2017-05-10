include "../interfaces/transactions_db_readerInterface.iol"
include "console.iol"

outputPort transactions_db_readerOutput {
	Location: "socket://localhost:8231"
	Protocol: sodep
	Interfaces: transactions_db_readerInterface
}

main
{
  /*
	// apikey info getter
  apikeyid.Id = 1;
  println@Console("Getting apikey info")();
  retrieve_apikey_info@transactions_db_readerOutput( apikeyid )( response );
  
  for( i=0, i<#response.APIKeyData, i++ ) {
    with ( response.APIKeyData[i] ) {
      println@Console( .IdMS )();
      println@Console( .IdClient )();
      println@Console( .Remaining )()
    }
  }
  */
  /*
  // purchases of a specific client lister
  clientid.Id = 1;
  println@Console("Getting purchases list of a specific client")();
  retrieve_purchases_list@transactions_db_readerOutput( clientid )( response );
  
  for( i=0, i<#response.PurchasesListData, i++ ) {
    println@Console( "Purchase number " + i )();
    with ( response.PurchasesListData[i] ) {
      println@Console( .IdPurchase )();
      println@Console( .Timestamp )();
      println@Console( .Price )();
      println@Console( .Amount )()
    }
  }
  */
}