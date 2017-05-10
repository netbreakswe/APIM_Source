type t0: string{
 .key:string 
}
type op: void {
  .a[1,1]:int
  .b[1,1]:int
  .key[1,1]:string
}

interface CalcServiceInterface {
 OneWay:
 RequestResponse:
   mock(t0)(string),
   div(op)(double),
   divanddouble(op)(double),
   sub(op)(double),
   subanddouble(op)(double),
   sumanddouble(op)(double),
   sum(op)(double)
}

outputPort CalcService_43 {
  Location:"socket://localhost:2002/!/CalcService_43"
  Protocol:sodep
  Interfaces: CalcServiceInterface
}