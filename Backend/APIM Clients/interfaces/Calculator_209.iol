type op: void {
  .a[1,1]:int
  .b[1,1]:int
  .api[1,1]:int
  .user[1,1]:string
  .key[1,1]:string
}

interface CalculatorInterface {
 OneWay:
 RequestResponse:
   div(op)(double),
   sub(op)(double),
   sumanddouble(op)(double),
   divanddouble(op)(double),
   sum(op)(double),
   subanddouble(op)(double)
}

outputPort Calculator_209 {
  Location:"socket://localhost:2002/!/Calculator_209"
  Protocol:sodep
  Interfaces: CalculatorInterface
}