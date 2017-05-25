include "../interfaces/transactions_dbInterface.iol"
include "console.iol"

outputPort transactions_dbJSONOutput {
  Location: "socket://localhost:8131"
  Protocol: http
  Interfaces: transactions_dbInterface
}

main
{

	// apikey info getter
  req.APIKey = "aaa";
  println@Console("ApiKey exists?")();
  check_apikey_exists@transactions_dbJSONOutput( req )( response );
  println@Console( response )()

}