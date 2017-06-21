type PowRequest: void {
	.x: double
	.y: double
}

type PowResponse: void {
	.result: double
}

interface powjavaInterface {
	RequestResponse:
		pow( PowRequest )( PowResponse )
}