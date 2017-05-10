type persone: void {
	.persona[0, *]: void {
		.nome:string
		.cognome:string
	}
}


type nomecognome:void {
	.nome:string
	.cognome:string
}


interface ProfileInterface { 
	RequestResponse: 
	getUsers( void )( persone ),	
	insertUser(nomecognome)(void)
}