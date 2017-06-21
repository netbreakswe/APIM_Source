
type javamailerrequest: void {
	.to: string
	.subject: string
	.body: string
}

interface JavaMailerInterface { 
	RequestResponse: mail( javamailerresquest )( string ) 
}