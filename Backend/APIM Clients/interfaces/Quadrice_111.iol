type t1: int {
 .key: string 
 .user: string 
 .api: int
}
interface QuadriceInterface {
 OneWay:
 RequestResponse:
   quadrice(t1)(int)
}

outputPort Quadrice_111 {
  Location:"socket://localhost:2002/!/Quadrice_111"
  Protocol:sodep
  Interfaces: QuadriceInterface
}