type PowRq: void {
	.x: double
	.y: double
}

type PowRs: void {
	.result: double
}

interface powInterface {
	RequestResponse:
		pow( PowRq )( PowRs )
}