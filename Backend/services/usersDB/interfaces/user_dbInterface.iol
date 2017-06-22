
// credenziali login

type logininfo: void {
	.Email: string
	.Password: string
}

// id

type id: void {
	.Id: int
}

// string id

type stringid: void {
	.Id: string
}

// rappresentazione admin

type admindata: void {
	.IdAdmin: string
	.Name: string
	.Surname: string
	.Email: string
	.Password: string
}

// rappr utente completo

type userdata: void {
	.IdClient: string
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

// rapr list utenti

type alluserdata : void {
	.users[0, *]: userdata
}

// rappr email di un utente

type email: void {
	.Email: string
}

// anagrafiche ed id dell'utente

type anagraphics: void {
	.Name: string
	.Surname: string
	.IdUser: string
}

// rappr id di un tipo account utente

type typeiddata: void {
	.ClientType: int
}

// rappr di una entry di moderazione

type entrydata: void {
	.IdEntry: int
	.IdClient: string
	.IdAdmin: string
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

// rappr di una lista di id developers

type devidlist: void {
	.devidlist[0,*]: stringid
}

// rappr di una lista di id client

type clientidlist: void {
	.clientidlist[0,*]: stringid
}

// rappr di un utente basic

type basicclientdata: void {
	.IdClient: string
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

// rappr di una entry di moderazione (senza campo id)

type smallentrydata: void {
	.IdClient: string
	.IdAdmin: string
	.Timestamp: string
	.ModType: int
	.Report: string
}

// rappr delle info che un utente può modificare (ed id per tracciarlo)

type userupdata: void {
	.IdClient: string
	.Name: string
	.Surname: string
	.Email: string
	.Avatar: string
	.AboutMe: string
	.Citizenship: string
	.LinkToSelf: string
	.PayPal: string
}

// rappr delle info per aggiornare i crediti di un utente

type creditsupdata: void {
	.IdClient: string
	.Credits: int
}

// rappr delle info per il cambio di password

type passupdata: void {
	.IdClient: string
	.Password: string
}

// read e write

interface user_dbInterface {
	RequestResponse:
	    user_exists( logininfo )( bool ),
	    admin_exists( logininfo )( bool ),
		retrieve_admin_info( stringid )( admindata ),
		retrieve_admin_info_from_email( email )( admindata ),
		retrieve_client_info( stringid )( userdata ),
		retrieve_all_dev_info( void )( alluserdata ),
		retrieve_all_client_info_from_id_subset( clientidlist )( alluserdata ),
		retrieve_client_info_from_email( email )( userdata ),
		retrieve_client_anagraphics( stringid )( anagraphics ),
		retrieve_client_type( id )( typeiddata ),
		retrieve_moderation_info( id )( entrydata ),
		retrieve_modtype_info( id )( modtypedata ),
		retrieve_clienttype_info( id )( clienttypedata ),
		retrieve_all_devid( void )( devidlist ),

		basicclient_registration( basicclientdata )( bool ),
		developer_upgrade( stringid )( void ),
		basicclient_downgrade( stringid )( void ),
		client_moderation( smallentrydata )( void ),
		client_update( userupdata )( void ),
		client_password_change( passupdata )( void ),
		client_delete( stringid )( void ),
		credits_update( creditsupdata )( void )
}