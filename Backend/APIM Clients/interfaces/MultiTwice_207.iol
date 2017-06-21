type twicetype: int {
  .usertwice[1,1]:string
  .apitwice[1,1]:int
  .keytwice[1,1]:string
  .api[1,1]:int
  .user[1,1]:string
  .key[1,1]:string
}

type t1: int {
 .key: string 
 .user: string 
 .api: int
}
interface MultiTwiceInterface {
 OneWay:
 RequestResponse:
   twice_APIcall(twicetype)(int),
   quadrice(t1)(int),
   thrice(t1)(int)
}

outputPort MultiTwice_207 {
  Location:"socket://localhost:2002/!/MultiTwice_207"
  Protocol:sodep
  Interfaces: MultiTwiceInterface
}