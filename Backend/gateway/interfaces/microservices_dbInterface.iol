
// id

type id: void {
	.Id: int
}

// lista di servizi con info per inizializzare outputportgateway

type listservices: void {
	.services[0, *]: string {
		.subservices[0, *]: void {
			.location:string
			.protocol:string
			.interfaces[0, *]: string 
		}
	}
}

// lista delle interfacce di un servizio

type listinterfaces: void {
	.subservices[0, *]: void {
		.location:string
		.protocol:string
		.interfaces[0, *]: string 
	}
}

// rappr microservizio

type msdata: void {
	.IdMS: int
	.Name: string
	.Description: string
	.Version: int
	.LastUpdate: string
	.IdDeveloper: int
	.Logo: string
	.DocPDF: string
	.DocExternal: string
	.Profit: int
	.IsActive: bool
	.SLAGuaranteed: double
	.Policy: int
}

// rappr interfaccia di un microservizio

type intfdata: void {
	.Interf: string
	.Loc: string
	.Protoc: string
}

// rappr id microservizio

type msiddata: void {
	.IdMS: int
}

// rappr dati di un microservizio

type msdataw: void {
	.data: raw
}

// rappr attributi modificabili di un microservizio

type msupdata: void {
	.IdMS: int
	.Name: string
	.Description: string
	.Version: int
	.LastUpdate: string
	.Logo: string
	.DocPDF: string
	.DocExternal: string
	.Profit: int
	.SLAGuaranteed: double
}

// appr attributi modificabili di una interfaccia

type intfupdata: void {
	.IdInterface: int
	.Interf: string
	.Loc: string
	.Protoc: string
}

// rappr di una categoria

type categorydata: void {
	.IdCategory: int
	.Name: string
	.Image: string
	.Description: string
}

// rappr di una lista di categorie

type categorydatalist: void {
	.categorydatalist[0,*]: categorydata
}

// rappr di una categoria (meno attributi)

type categorydataw: void {
	.IdMS: int
	.IdCategory: int
}

// rappr delle informazioni di una interfaccia

type Info_Interf: void {
	.operations[0, *]: void {
		.name: string
		.request: string
		.response: any
		.description?: string
		.ecceptions[0, *]: void {
			.name: string
			.param: string
		}
	}
	.types[0, *]: void {
		.name: string
		.definition: string
	}
	.client_Interface?:string
}

// rappr di una lista di categorie

type categorylist: void {
	.categories[0,*]: void {
		.IdCategory: int
		.Name: string
		.Image: string
	}
}

// rappr della lista di microservizio per la homepage

type home_ms_list: void {
	.services[0,*]: void {
		.Name: string
		.Logo: string
		.IdMS: int
		.IdDeveloper: int
		.categories[0, *]: void {
			.IdCategory: int
			.CatName: string
		}
	}
}

// rappr degli attributi modificabili di una interfaccia

type Info_Interf_update: void {
	.Id: int
	.data: raw
}

// rappr di una lista di microservizio ottenuta dall'id del developer

type msdevlist: void {
	.msdevdata[0,*]: void {
		.IdMS: int
		.Name: string
		.Logo: string
		.IsActive: bool
	}
}


// read e write

interface microservices_dbInterface {
	RequestResponse:
		retrieve_all_ms_gateway_meta( void )( listservices ),
		retrieve_client_interface_from_id( id )( Info_Interf ),
		homepage_ms_list( void) ( home_ms_list ),
		retrieve_ms_info( id )( msdata ),
		retrieve_intf_info( id )( intfdata ),
		retrieve_ms_from_developerid( id )( msdevlist ),
		retrieve_interfaces_of_ms( id )( listinterfaces ),
		retrieve_ms_from_interface( id )( msiddata ),
		retrieve_category_info( id )( categorydata ),
		retrieve_category_list( void )( categorylist ),
		retrieve_categories_of_ms( id )( categorydatalist ),

		microservice_registration( msdataw )( int ),
		microservice_update( msupdata )( void ),
		interface_update( intfupdata )( void ),
		add_category_to_ms( categorydataw )( void ),
		remove_category_from_ms( categorydataw )( void ),
		update_client_interface_by_id( Info_Interf_update )( void )
}