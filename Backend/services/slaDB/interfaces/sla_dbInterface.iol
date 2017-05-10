// strutture dati con solo id

type apikeyid: void {
	.Id: int
}

type msid: void {
	.Id: int
}

type slasurveyid: void {
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
	.IdAPIKey: int
	.IdMS: int
	.Timestamp: string
	.ResponseTime: string
	.IsCompliant: bool
}

interface sla_dbInterface {
	RequestResponse:
	    //GETTERS
		retrieve_apikey_slasurvey_list( apikeyid )( slasurveylist ),
		retrieve_ms_slasurvey_list( msid )( slasurveylistms ),
		retrieve_slasurvey_info( slasurveyid )( slasurvey ),
		retrieve_slasurvey_iscompliant( slasurveyid )( bool ),

		//SETTERS
		slasurvey_insert( slasurveydataw )( void )
}