type t1: int {
 .key: string 
 .user: string 
 .api: int
}
interface ThriceInterface {
 OneWay:
 RequestResponse:
   thrice(t1)(int)
}

outputPort Thrice_110 {
  Location:"socket://localhost:2002/!/Thrice_110"
  Protocol:sodep
  Interfaces: ThriceInterface
}