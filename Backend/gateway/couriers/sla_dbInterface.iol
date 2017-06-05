
type id: void {
	.Id: int
}

// retrieve sla survey info from specific api key

type slasurveylistdata: void {
	.IdMS: int
	.Timestamp: string
	.ResponseTime: double
	.IsCompliant: bool
}

type slasurveylist: void {
	.SlaSurveyListData [0,*]: slasurveylistdata
}

// retrieve sla survey info from specific ms

type slasurveylistmsdata: void {
	.Timestamp: string
	.ResponseTime: double
	.IsCompliant: bool
}

type slasurveylistms: void {
	.SlaSurveyListMSData [0,*]: slasurveylistmsdata
}

// retrieve sla survey info

type slasurveydata: void {
	.IdSLASurvey: int
	.IdMS: int
	.Timestamp: string
	.ResponseTime: double
	.IsCompliant: bool
}

type slasurvey: void {
	.SlaSurveyData: slasurveydata
}

// insert new sla survey 

type slasurveydataw: void {
	.APIKey: string
	.IdMS: int
	.Timestamp: string
	.ResponseTime: double
	.IsCompliant: bool
}


// read e write

interface sla_dbInterface {
	RequestResponse:
		retrieve_apikey_slasurvey_list( id )( slasurveylist ),
		retrieve_ms_slasurvey_list( id )( slasurveylistms ),
		retrieve_slasurvey_info( id )( slasurvey ),
		retrieve_slasurvey_iscompliant( id )( bool ),

		slasurvey_insert( slasurveydataw )( void )
}