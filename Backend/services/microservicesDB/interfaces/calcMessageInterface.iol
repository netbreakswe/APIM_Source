type CalcRequest: undefined

type CalcResponse: void {
	.bytesize: int
}

interface calcMessageInterface {
	RequestResponse:
		calcMessage( CalcRequest )( CalcResponse )
}