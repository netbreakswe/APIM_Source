type t0: string{
 .key:string 
}
type Request: void {
  .destination[1,1]:string
  .content[1,1]:string
  .key[1,1]:string
}

type mailreq: void {
  .mail[1,1]:string
  .content[1,1]:string
  .key[1,1]:string
}

type t1: int{
 .key:string 
}
interface CommServiceInterface {
 OneWay:
   faxwithnoresponse(Request),
   mailwithnoresponse(mailreq)
 RequestResponse:
   mock(t0)(string),
   fax(Request)(string),
   mail(mailreq)(string),
   sayhello(t0)(string),
   saysuperhello(t0)(string),
   sayagreeting(t1)(string)
}

outputPort CommService_11 {
  Location:"socket://localhost:2002/!/CommService_11"
  Protocol:sodep
  Interfaces: CommServiceInterface
}