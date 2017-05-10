include "metajolie.iol"
include "metaparser.iol"
include "string_utils.iol"

/*SIMPLE TYPES*/
/*directory del file courier da cui estrarre le metainfo*/
type courierdir: string 

/*la rappresentazione a stringa del file courier .ol*/
type courierservice: string

/*la rappresentazione a stringa dell'interfaccia client'*/
type clientinterface: string

/*COMPLES TYPES*/
/*servizio a partire dal quale generare il file courier*/
type aaservice: string {
	.subservices[0, *]: void {
		.location:string
		.protocol:string
		.interfaces[0, *]: string 
	}
}

/*metainformazioni di un servizio apim generate a partire da un courier*/
type MetaInfoAPIMService: void {
	.operations[0, *]: void {
		.name: string
		.request: string
		.response?: string
		.ecceptions[0, *]: void {
			.name: string
			.param: string
		}
	}
	.types[0, *]: string {
		.name: string
		.definition: string
	}
	.ms_id?: int
	.ms_name?: string
}

interface ServiceInteractionHandlerInterface {
  RequestResponse:
    getServiceMetaFromCourier( courierdir )( MetaInfoAPIMService ),
    generateClientInterface( MetaInfoAPIMService )( clientinterface ),
    generateCourier( aaservice )( courierservice )
}