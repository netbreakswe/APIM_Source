type t1: int {
 .key: string 
 .user: string 
 .api: int
}
interface TwiceInterface {
 OneWay:
 RequestResponse:
   twice(t1)(int)
}

outputPort Twice_109 {
  Location:"socket://localhost:2002/!/Twice_109"
  Protocol:sodep
  Interfaces: TwiceInterface
}