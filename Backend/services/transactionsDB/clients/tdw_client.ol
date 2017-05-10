include "../interfaces/transactions_db_writerInterface.iol"
include "console.iol"

outputPort transactions_db_writerOutput {
	Location: "socket://localhost:8231"
	Protocol: sodep
	Interfaces: transactions_db_writerInterface
}

main
{
	/*
	// apikey registration
	with( apikeydataw ) {
		.IdMS = 7;
    .IdClient = 2;
    .Remaining = 100
	};
	apikey_registration@transactions_db_writerOutput( apikeydataw )( void );
	println@Console("Registered new apikey")()
	*/
  /*
  // purchase registration
  with( purchasedata ) {
    .IdAPIKey = 3;
    .IdClient = 2;
    .Timestamp = "2017-04-26";
    .Price = 7;
    .Amount = 100
  };
  purchase_registration@transactions_db_writerOutput( purchasedata )( void );
  println@Console("Registered new purchase")()
  */
  /*
  // apikey remaining update (positive number)
  with( apikeyremainingdata ) {
    .IdAPIKey = 3;
    .Number = 1
  };
  apikey_remaining_update@transactions_db_writerOutput( apikeyremainingdata )();
  println@Console("Updated remaining of apikey with id " + apikeyremainingdata.IdAPIKey + " with number " + apikeyremainingdata.Number)()
  */
  /*
  // apikey remaining update (negative number)
  with( apikeyremainingdata ) {
    .IdAPIKey = 3;
    .Number = -2
  };
  apikey_remaining_update@transactions_db_writerOutput( apikeyremainingdata )();
  println@Console("Updated remaining of apikey with id " + apikeyremainingdata.IdAPIKey + " with number " + apikeyremainingdata.Number)()
  */
}