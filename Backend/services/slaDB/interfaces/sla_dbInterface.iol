
type id: void {
	.Id: int
}

// retrieve sla survey info from specific api key

type slasurveylistdata: void {
	.IdMS: int
	.Timestamp: long
	.ResponseTime: long
	.IsCompliant: bool
}

type slasurveylist: void {
	.SlaSurveyListData [0,*]: slasurveylistdata
}

// retrieve sla survey info from specific ms

type slasurveylistmsdata: void {
	.Timestamp: long
	.ResponseTime: long
	.IsCompliant: bool
}

type slasurveylistms: void {
	.SlaSurveyListMSData [0,*]: slasurveylistmsdata
}

// retrieve sla survey info

type slasurveydata: void {
	.IdSLASurvey: int
	.IdMS: int
	.Timestamp: long
	.ResponseTime: long
	.IsCompliant: bool
}

type slasurvey: void {
	.SlaSurveyData: slasurveydata
}

// insert new sla survey 

type slasurveydataw: void {
	.APIKey: string
	.IdMS: int
	.Timestamp: long
	.ResponseTime: long
	.IsCompliant: bool
}

// rappr di una chiamata API

type calldata: void {
	.IdSLASurvey: int
	.Timestamp: long
	.ResponseTime: long
	.IsCompliant: bool
} 

// rappr di una lista di chiamate API

type callslist: void {
	.callslist[0,*]: calldata
}


// read e write

interface sla_dbInterface {
	RequestResponse:
		retrieve_apikey_slasurvey_list( id )( slasurveylist ),
		retrieve_ms_slasurvey_list( id )( slasurveylistms ),
		retrieve_slasurvey_info( id )( slasurvey ),
		retrieve_slasurvey_iscompliant( id )( bool ),
		retrieve_average_response_time_from_msid( id )( long ),
		retrieve_calls_list_from_msid( id )( callslist ),

		slasurvey_insert( slasurveydataw )( void )
}