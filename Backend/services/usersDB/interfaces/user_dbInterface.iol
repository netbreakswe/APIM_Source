
// credenziali login

type logininfo: void {
	.Email: string
	.Password: string
}

// id

type id: void {
	.Id: int
}

// rappresentazione admin

type admindata: void {
	.IdAdmin: int
	.Name: string
	.Surname: string
	.Email: string
	.Password: string
}

// rappr utente completo

type userdata: void {
	.IdClient: int
	.Name: string
	.Surname: string
	.Email: string
	.Password: string
	.Avatar: string
	.Credits: int
	.ClientType: int
	.Registration: string
	.AboutMe: string
	.Citizenship: string
	.LinkToSelf: string
	.PayPal: string
}

// rappr email di un utente

type email: void {
	.Email: string
}

// anagrafiche ed id dell'utente

type anagraphics: void {
	.Name: string
	.Surname: string
	.IdUser: int
}

// rappr id di un tipo account utente

type typeiddata: void {
	.ClientType: int
}

// rappr di una entry di moderazione

type entrydata: void {
	.IdEntry: int
	.IdClient: int
	.IdAdmin: int
	.Timestamp: string
	.ModType: int
	.Report: string
}

// rappr di un tipo di moderazione

type modtypedata: void {
	.IdModType: int
	.Name: string
	.Description: string
}

// rappr di un tipo di account utente

type clienttypedata: void {
	.IdClientType: int
	.Name: string
	.Description: string
}

// rappr di un utente basic

type basicclientdata: void {
	.Name: string
	.Surname: string
	.Email: string
	.Password: string
	.Avatar: string
	.AboutMe: string
	.Citizenship: string
	.LinkToSelf: string
	.PayPal: string
}

// rappr di un utente developer

type developerdata: void {
	.IdClient: int
	.AboutMe: string
	.Citizenship: string
	.LinkToSelf: string
	.PayPal: string
}

// rappr di una entry di moderazione (senza campo id)

type smallentrydata: void {
	.IdClient: int
	.IdAdmin: int
	.Timestamp: string
	.ModType: int
	.Report: string
}

// rappr delle info che un utente può modificare (ed id per tracciarlo)

type userupdata: void {
	.IdClient: int
	.Name: string
	.Surname: string
	.Email: string
	.Avatar: string
	.AboutMe: string
	.Citizenship: string
	.LinkToSelf: string
	.PayPal: string
}


// read e write

interface user_dbInterface {
	RequestResponse:
	    user_exists( logininfo )( bool ),
		retrieve_admin_info( id )( admindata ),
		retrieve_client_info( id )( userdata ),
		retrieve_client_info_from_email( email )( userdata ),
		retrieve_client_anagraphics( id )( anagraphics ),
		retrieve_client_type( id )( typeiddata ),
		retrieve_moderation_info( id )( entrydata ),
		retrieve_modtype_info( id )( modtypedata ),
		retrieve_clienttype_info( id )( clienttypedata ),

		basicclient_registration( basicclientdata )( bool ),
		developer_upgrade( developerdata )( void ),
		basicclient_downgrade( id )( void ),
		client_moderation( smallentrydata )( void ),
		client_update( userupdata )( void ),
		client_delete( id )( void )
}