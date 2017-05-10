include "../interfaces/microservices_db_writerInterface.iol"
include "console.iol"

outputPort microservices_db_writerOutput {
	Location: "socket://localhost:8221"
	Protocol: sodep
	Interfaces: microservices_db_writerInterface
}

main
{
	/*
	// microservice registration
	with( msdataw ) {
		.Name = "GoodbyeService";
      	.Description = "Stampa goodbye";
      	.Version = 2;
      	.LastUpdate = "2017-04-06";
      	.IdDeveloper = 2;
      	.Logo = "https://goodbyes/logo.it";
      	.DocPDF = "Un qualche pdf";
      	.DocExternal = "https://goodbye/doc.it";
      	.Profit = 3;
      	.IsActive = false;
      	.SLAGuaranteed = 2;
      	.Policy = 1
	};
	microservice_registration@microservices_db_writerOutput( msdataw )( void );
	println@Console("Registered new microservice")()
	*/
	/*
  // modify microservice
  with( msupdata ) {
	  .IdMS = 7;
		.Name = "GoodbyeServicee";
    .Description = "Stampa goodbyee";
    .Version = 3;
    .LastUpdate = "2017-04-26";
    .Logo = "https://goodbyees/logo.it";
    .DocPDF = "Un qualchee pdf";
    .DocExternal = "https://goodbyee/doc.it";
    .Profit = 4;
    .SLAGuaranteed = 1
	};
  microservice_update@microservices_db_writerOutput( msupdata )();
  println@Console("Modified microservice with id " + msupdata.IdMS)()
  */
  /*
  // interface registration
  with( intfdataw ) {
    .IdMS = 7;
    .Interf = "typedef goodbye: void {}\r\n\r\ninterface goodbye {}";
    .Loc = "socket://localhost:8010";
    .Protoc = "sodep"
  };
  interface_registration@microservices_db_writerOutput( intfdataw )( void );
  println@Console("Registered new interface")()
  */
  /*
  // modify interface
  with( intfupdata ) {
    .IdInterface = 9;
    .Interf = "typedeff goodbye: void {}\r\n\r\ninterface goodbye {}";
    .Loc = "socketf://localhost:8010";
    .Protoc = "sodepf"
  };
  interface_update@microservices_db_writerOutput( intfupdata )();
  println@Console("Modified interface with id " + intfupdata.IdMS)()
  */
  /*
  // add category to microservice
  with( categorydata ) {
    .IdMS = 7;
    .IdCategory = 3
  };
  add_category_to_ms@microservices_db_writerOutput( categorydata )();
  println@Console("Added new category to microservice " + categorydata.IdMS)()
  */
  /*
  // remove category from microservice
  with( categorydata ) {
    .IdMS = 7;
    .IdCategory = 3
  };
  remove_category_from_ms@microservices_db_writerOutput( categorydata )();
  println@Console("Removed category to microservice " + categorydata.IdMS)()
  */
}