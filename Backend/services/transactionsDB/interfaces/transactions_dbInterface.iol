
// id

type id: void {
	.Id: int
}

// rappresentazione di una apikey

type apikeydata: void {
	.APIKey: string
	.IdMS: int
	.IdClient: int
	.Remaining: int
}

// rappr di una apikey

type apikey: void {
	.APIKeyData: apikeydata
}

// rappr di una stringa univoca della licenza di una apikey

type apikeylicense: void {
	.License: string
}

// rappr di un acquisto

type purchasedata: void {
	.IdPurchase: int
	.APIKey: string
	.IdClient: int
	.Timestamp: string
	.Amount: int
	.Type: string
} 

// rappr di una lista di acquisti

type purchaseslist: void {
	.purchaseslist[0,*]: purchasedata
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

// rappr di un acquisto (senza id)

type smallpurchasedata: void {
	.APIKey: string
	.IdClient: int
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
		apikey_exists( apikey )( bool ),
		retrieve_apikey_info( apikeylicense )( apikeydata ),
		retrieve_purchases_list_from_userid( id )( purchaseslist ),
		retrieve_active_apikey_from_userid( id )( apikeyslist ),
		retrieve_active_apikey_number_from_msid( id )( apikeynumber ),

		apikey_registration( apikeydata )( void ),
		purchase_registration( smallpurchasedata )( void ),
		apikey_remaining_update( apikeyremainingdata )( void )
}