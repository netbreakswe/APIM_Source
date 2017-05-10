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