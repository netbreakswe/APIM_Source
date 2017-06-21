type t1: int {
 .key: string 
 .user: string 
 .api: int
}
interface MultipliceInterface {
 OneWay:
 RequestResponse:
   quadrice(t1)(int),
   thrice(t1)(int)
}

outputPort Multiplice_112 {
  Location:"socket://localhost:2002/!/Multiplice_112"
  Protocol:sodep
  Interfaces: MultipliceInterface
}