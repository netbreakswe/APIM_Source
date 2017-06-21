type twicetype: int {
	.keytwice: string 
	.usertwice: string 
	.apitwice: int
}

interface MultiTwiceInterface { 
	RequestResponse:
		twice_APIcall( twicetype )( int ),
		thrice( int )( int ),
		quadrice( int )( int )
}