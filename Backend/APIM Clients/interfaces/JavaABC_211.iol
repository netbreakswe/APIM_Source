type t1: void {
 .key: string 
 .user: string 
 .api: int
}
interface JavaABCInterface {
 OneWay:
 RequestResponse:
   getA(t1)(string),
   getB(t1)(string),
   getC(t1)(string)
}

outputPort JavaABC_211 {
  Location:"socket://localhost:2002/!/JavaABC_211"
  Protocol:sodep
  Interfaces: JavaABCInterface
}