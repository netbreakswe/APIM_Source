include "file.iol"

/*servizio a partire dal quale generare il file courier*/
type aservice: string {
	.subservices[0, *]: void {
		.location:string
		.protocol:string
		.interfaces[0, *]: string 
	}
}

interface RedirectorInterface {
RequestResponse:
	setnewredirection( aservice )( void )
}