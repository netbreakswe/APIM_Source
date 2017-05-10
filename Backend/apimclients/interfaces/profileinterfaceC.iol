type persone: void {
	.persona[0, *]: void {
		.nome:string
		.cognome:string
	}
}

type nomecognome:void {
	.key: string
	.nome:string
	.cognome:string
}

type profilet1:void {
	.key:string
}

interface ProfileInterfaceC { 
	RequestResponse: 
	getUsers( profilet1 )( persone ),	
	insertUser(nomecognome)(void)
}

outputPort ProfileService{
  Location:"socket://localhost:2002/!/Service6"
  Protocol:sodep
  Interfaces: ProfileInterfaceC
}