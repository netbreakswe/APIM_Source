
// id

type id: void {
	.Id: int
}

// string id

type stringid: void {
	.Id: string
}

// rappresentazione di una apikey

type apikeydata: void {
	.APIKey: string
	.IdMS: int
	.IdClient: string
	.Remaining: int
}

// rappr minima di una apikey

type apikey: void {
	.APIKey: string
	.IdClient: string
}

// rappr di una stringa univoca della licenza di una apikey

type apikeylicense: void {
	.License: string
}

// rappr di idclient ed idms per verificare la validità di una apikey

type apikeyactivedata: void {
	.IdClient: string
	.IdMS: int
}

// rappr di una lista di apikey

type apikeyslist: void {
	.apikeyslist[0,*]: apikeydata
}

// rappr del numero di licenze attive di un ms con il rispettivo id ms

type apikeynumber: void {
	.IdMS: int
	.Licenses: int
}

// rappr di un acquisto

type purchasedata: void {
	.IdPurchase: string
	.APIKey: string
	.IdClient: string
	.Timestamp: string
	.Amount: int
	.Type: string
} 

// rappr di una lista di acquisti

type purchaseslist: void {
	.purchaseslist[0,*]: purchasedata
}

type msremainingdata: void {
	.IdMS: int
	.Remaining: int
}

// rappr della lista di id e remaining di un microservizio

type msremaininglist: void {
	.msremaininglist[0,*]: msremainingdata
}

// rappr di un acquisto (senza id)

type smallpurchasedata: void {
	.APIKey: string
	.IdClient: string
	.Timestamp: string
	.Amount: int
	.Type: string
} 

// apikey remaining update

type apikeyremainingdata: void {
	.APIKey: string
	.Number: int
}


// read e write

interface transactions_dbInterface {
	RequestResponse:
		check_apikey_exists( apikey )( bool ),
		retrieve_apikey_info( apikeylicense )( apikeydata ),
		check_apikey_isactive( apikeyactivedata )( bool ),
		retrieve_active_apikey_from_userid( stringid )( apikeyslist ),
		retrieve_active_apikey_number_from_msid( id )( apikeynumber ),
		retrieve_purchases_list_from_userid( stringid )( purchaseslist ),
		retrieve_mslist_from_clientid( stringid )( msremaininglist ),

		apikey_registration( apikeydata )( void ),
		purchase_registration( smallpurchasedata )( void ),
		apikey_remaining_update( apikeyremainingdata )( void )
}