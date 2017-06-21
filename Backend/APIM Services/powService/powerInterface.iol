type powr: void {
	.x: double
	.y: double
}

interface powerInterface {
	RequestResponse:
		power( powr )( double )
}