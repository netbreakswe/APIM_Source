include "../interfaces/sla_db_writerInterface.iol"
include "console.iol"

outputPort sla_db_writerOutput {
	Location: "socket://localhost:8212"
	Protocol: sodep
	Interfaces: sla_db_writerInterface
}

main
{
	
	// insert sla survey
	with( slasurveydataw ) {
		.IdAPIKey = 3;
		.IdMS = 2;
		.Timestamp = "2017-04-06 20:52:20";
		.ResponseTime = "0.167";
		.IsCompliant = true
	};
	slasurvey_insert@sla_db_writerOutput( slasurveydataw )( void );
	println@Console("Inserted new sla survey")()
	
}