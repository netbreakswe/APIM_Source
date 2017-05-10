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
