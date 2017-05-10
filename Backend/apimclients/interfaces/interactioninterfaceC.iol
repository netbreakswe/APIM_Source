type hellot1:string {
	.key:string
}

type hellot2:int {
	.key:string
}

type FaxRequestExt:void {
	.key:string
	.destination:string
	.content:string
}

type mailreq:void {
  .key:string
  .mail:string
  .content:string
}

interface InteractionInterfaceC {
  RequestResponse:
    mock( string )( string ),
    sayhello( hellot1 )( string ),
    saysuperhello(hellot1)(string),
    sayagreeting(hellot2)(string),
	  fax( FaxRequestExt )( string ),
    mail( mailreq )( string )

  OneWay:
    mailwithnoresponse( mailreq ),
    faxwithnoresponse( FaxRequestExt )


}

outputPort InteractionService{
  Location:"socket://localhost:2002/!/Service4"
  Protocol:sodep
  Interfaces: InteractionInterfaceC
}