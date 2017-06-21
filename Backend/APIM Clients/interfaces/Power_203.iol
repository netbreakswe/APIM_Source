type powr: void {
  .x[1,1]:double
  .y[1,1]:double
  .api[1,1]:int
  .user[1,1]:string
  .key[1,1]:string
}

interface PowerInterface {
 OneWay:
 RequestResponse:
   power(powr)(double)
}

outputPort Power_203 {
  Location:"socket://localhost:2002/!/Power_203"
  Protocol:sodep
  Interfaces: PowerInterface
}