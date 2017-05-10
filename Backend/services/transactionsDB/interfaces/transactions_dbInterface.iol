// strutture dati con solo id

type apikeyid: void {
	.Id: int
}

type clientid: void {
	.Id: int
}

// retrieve apikey info

type apikeydata: void {
	.IdMS: int
	.IdClient: int
	.Remaining: int
}

type apikey: void {
	.APIKeyData: apikeydata
}

// retrieve purchases list of a client

type purchaseslistdata: void {
	.IdPurchase: int
	.Timestamp: string
	.Price: int
	.Amount: int
} 

type purchaseslist: void {
	.PurchasesListData [0,*]: purchaseslistdata
}

// apikey registration

type apikeydataw: void {
	.IdMS: int
	.IdClient: int
	.Remaining: int
}

// purchase registration
type purchasedata: void {
	.IdAPIKey: int
	.IdClient: int
	.Timestamp: string
	.Price: int
	.Amount: int
}

// apikey remaining update
type apikeyremainingdata: void {
	.IdAPIKey: int
	.Number: int
}

interface transactions_dbInterface {
	RequestResponse:
	    //GETTERS
		apikey_exists(apikey)(bool),
		retrieve_apikey_info( apikeyid )( apikey ),
		retrieve_purchases_list( clientid )( purchaseslist ),

        //SETTERS
		apikey_registration( apikeydataw )( void ),
		purchase_registration( purchasedata )( void ),
		apikey_remaining_update( apikeyremainingdata )( void )
}