type req: void {
	.key:string
}

interface JavaInterfaceC {
	RequestResponse: 
		getA(req)( string ),	
		getB(req)(string),
		getC(req)(string)
}

outputPort JavaService{
  Location:"socket://localhost:2002/!/Service5"
  Protocol:sodep
  Interfaces: JavaInterfaceC
}