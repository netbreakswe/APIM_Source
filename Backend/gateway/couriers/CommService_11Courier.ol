include "transactions_dbInterface.iol"
include "sla_dbInterface.iol"

type Request:void {
	.destination:string
	.content:string
}

interface FaxInterface {
	OneWay:
		faxwithnoresponse( Request ) 
	RequestResponse:
		fax(Request)( string )
}


type mailreq:void {
	.mail:string
	.content:string
}

interface MailInterface {
	OneWay:
		mailwithnoresponse( mailreq ) 
	RequestResponse:
		mail(mailreq)( string )
}

interface HelloInterface {
  RequestResponse:
    sayhello( string )( string ),
    saysuperhello(string)(string),
    sayagreeting(int)(string)
}

type AuthenticationData: any {
 .key: string
 .user: string
 .api: int
}

interface extender AuthInterfaceExtender {
  RequestResponse:
    *( AuthenticationData )( void )
  OneWay:
    *( AuthenticationData )
}

interface AggregatorInterface {
  RequestResponse:
    mock(string)(string)
}

outputPort transactions_dbOutput {
 Location: "socket://localhost:8131"
 Protocol: http
 Interfaces: transactions_dbInterface
}

outputPort sla_dbOutput {
 Location: "socket://localhost:8141"
 Protocol: http
 Interfaces: sla_dbInterface
}

outputPort SubService0 {
 Interfaces: FaxInterface, MailInterface
 Location: "socket://localhost:9202"
 Protocol: sodep
}

outputPort SubService1 {
 Interfaces: HelloInterface
 Location: "socket://localhost:9500"
 Protocol: http
}

inputPort Client {
 Location: "local"
 Interfaces: AggregatorInterface
 Aggregates: SubService0 with AuthInterfaceExtender, SubService1 with AuthInterfaceExtender 
}

 courier Client {
  [ interface FaxInterface( request )( response ) ] {
    requestinfo.APIKey = request.key;
    requestinfo.IdClient = request.user;
    requestinfo.IdMS = request.api;
    check.APIKey = requestinfo.APIKey;
    check.IdClient = requestinfo.IdClient;
    check.IdMS = requestinfo.IdMS;
    check_apikey_exists@transactions_dbOutput( check )( validity );
    if( validity ) {
      forward ( request )( response );
      slasurvey.APIKey = requestinfo.APIKey;
      slasurvey.IdMS = requestinfo.IdMS;
      slasurvey.Timestamp = "2017-06-05 12:11:10";
      slasurvey.ResponseTime = 10;
      slasurvey.IsCompliant = true;
	   slasurvey_insert@sla_dbOutput( slasurvey )( void )
    }
  }
  [ interface MailInterface( request )( response ) ] {
    requestinfo.APIKey = request.key;
    requestinfo.IdClient = request.user;
    requestinfo.IdMS = request.api;
    check.APIKey = requestinfo.APIKey;
    check.IdClient = requestinfo.IdClient;
    check.IdMS = requestinfo.IdMS;
    check_apikey_exists@transactions_dbOutput( check )( validity );
    if( validity ) {
      forward ( request )( response );
      slasurvey.APIKey = requestinfo.APIKey;
      slasurvey.IdMS = requestinfo.IdMS;
      slasurvey.Timestamp = "2017-06-05 12:11:10";
      slasurvey.ResponseTime = 10;
      slasurvey.IsCompliant = true;
	   slasurvey_insert@sla_dbOutput( slasurvey )( void )
    }
  }
  [ interface HelloInterface( request )( response ) ] {
    requestinfo.APIKey = request.key;
    requestinfo.IdClient = request.user;
    requestinfo.IdMS = request.api;
    check.APIKey = requestinfo.APIKey;
    check.IdClient = requestinfo.IdClient;
    check.IdMS = requestinfo.IdMS;
    check_apikey_exists@transactions_dbOutput( check )( validity );
    if( validity ) {
      forward ( request )( response );
      slasurvey.APIKey = requestinfo.APIKey;
      slasurvey.IdMS = requestinfo.IdMS;
      slasurvey.Timestamp = "2017-06-05 12:11:10";
      slasurvey.ResponseTime = 10;
      slasurvey.IsCompliant = true;
	   slasurvey_insert@sla_dbOutput( slasurvey )( void )
    }
  }
  [ interface FaxInterface( request ) ] {
    forward ( request )
  }
  [ interface MailInterface( request ) ] {
    forward ( request )
  }
  [ interface HelloInterface( request ) ] {
    forward ( request )
  }
 }

main {
  mock( r )( rs ) {
    rs = void
  }
}
