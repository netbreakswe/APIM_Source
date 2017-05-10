// strutture dati con semplice id

type msid: void {
	.Id: int
}//

type intfid: void {
	.Id: int
}//


/*lista di servizi con info per inizializzare outputportgateway*/
type listservices: void {
	.services[0, *]: string {
		.subservices[0, *]: void {
			.location:string
			.protocol:string
			.interfaces[0, *]: string 
		}
	}
}//

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
}//

type intfdata: void {
	.Interf: string
	.Loc: string
	.Protoc: string
}//

type msiddata: void {
	.IdMS: int
}//

type msdataw: void {
	.data: raw
}//

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
}//

type intfupdata: void {
	.IdInterface: int
	.Interf: string
	.Loc: string
	.Protoc: string
}//

type categorydataw: void {
	.IdMS: int
	.IdCategory: int
}//


type categoryidlist: void {
	.CategoryIdListData [0,*]:  void {
		.IdCategory: int
		.Name: string
		.Image: string
	} 
}//


type intfidlist: void {
	.IntfIdListData [0,*]: void {
		.IdInterface: int
	} 
}//

type Info_Interf: void {
	.operations[0, *]: void {
		.name: string
		.request: string
		.response?: string
		.ecceptions[0, *]: void {
			.name: string
			.param: string
		}
	}
	.types[0, *]: void {
		.name: string
		.definition: string
	}
	.client_Interface:string
}//

type categorylist: void {
	.categories[0,*]: void {
		.IdCategory: int
		.Name: string
		.Image: string
	}
} //

type home_ms_list: void {
	.services[0,*]: void {
		.Name: string
		.Logo: string
		.IdMS: int
		.IdDeveloper: int
		.categories[0, *]: int
	}
} //





interface microservices_dbInterface {
	RequestResponse:
	    //getters
		retrieve_all_ms_gateway_meta( void )( listservices ), 
		retrieve_interface_by_id(msid)(Info_Interf),
		homepage_ms_list(void)(home_ms_list),
		retrieve_ms_info( msid )( msdata ),
		retrieve_intf_info( intfid )( intfdata ),
		retrieve_interfaces_of_ms( msid )( intfidlist ),
		retrieve_ms_from_interface( intfid )( msiddata ),
		retrieve_category_info( void )( categorylist ), 
		retrieve_categories_of_ms( msid )( categoryidlist ),

        //setters
		microservice_registration( msdataw )( void ),
		microservice_update( msupdata )( void ),
		interface_update( intfupdata )( void ),
		add_category_to_ms( categorydataw )( void ),
		remove_category_from_ms( categorydataw )( void ),
}