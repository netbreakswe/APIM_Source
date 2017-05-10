include "runtime.iol"
include "console.iol"
include "interfaces/redirectorinterface.iol"
include "interfaces/microservices.iol"
include "interfaces/serviceinteractionhandlerinterface.iol"

execution { concurrent }





/*porta per comunicare con microservices_db_reader.ol*/
outputPort MicroservicesDB {
  Location: "socket://localhost:8121"
  Protocol: http
  Interfaces: microservices_dbInterface
}

/*porta per comunicare con gestore delle interazioni dei microservizi*/
outputPort ServiceInteractionHandler {
   Location: "socket://localhost:8322"
   Protocol: http 
   Interfaces: ServiceInteractionHandlerInterface
}


inputPort Gateway {
  Location: "socket://localhost:2002"
  Protocol: sodep
  Interfaces: RedirectorInterface
}









/*1. Procedura che effettua embedding/redirection dinamica di un requester per ogni servizio sulla base del nome risorsa*/
define __newcourierredirection {
  //embeddo dinamicamente servizio
  with( emb ) {
      .filepath = "couriers/"+__serviceid+"Courier.ol";
      .type = "Jolie" //possibilmente da fare ancora piu' dinamico includendo il resto dei tipi possibili
   };
  loadEmbeddedService@Runtime( emb )(handle);
  println@Console(__serviceid + ": Courier with filename " +__serviceid + "Courier.ol loaded into Gateway")();
  //associo il servizio embeddato a una outputport creata al volo univoca
  with (opnew) {
    .location = handle;
    .name = __serviceid+"Courier"
  };
  setOutputPort@Runtime( opnew )();
  println@Console(__serviceid + ": Created Outputport of " +__serviceid + " with Name "+ __serviceid+"Courier")();
  //imposto redirezione dinamica sulla porta associata al servizio col courier
  with( redirection ){
    .outputPortName = __serviceid+"Courier";
    .resourceName = __serviceid;
    .inputPortName = "Gateway"
  };
  setRedirection@Runtime ( redirection )();
  println@Console(__serviceid + ": Dynamic redirection of service set on "+ __serviceid + "Courier port")()
}









init {
  /*ricavo info di binding di tutti i microservizi*/
  println@Console("Start init of gateway:")();
  retrieve_all_ms_gateway_meta@MicroservicesDB( void )( mss );
  /*genero 'couriers' per ogni microservizio*/
  for (i = 0, i < #mss.services, i++) {
      generateCourier@ServiceInteractionHandler(mss.services[i])(courier_s);
      __serviceid = mss.services[i]; 
      println@Console(__serviceid + ": Courier written on local File with Name: " + __serviceid + "Courier.ol")();
      with (filereq) {
         .content = courier_s;
         .filename = "couriers/"+__serviceid +"Courier.ol"
      };
      writeFile@File(filereq)();
      __newcourierredirection;
      println@Console(__serviceid + ": SUCCESS")()
  }     
}






main
{
  [setnewredirection( request )(response) {
      generateCourier@ServiceInteractionHandler(request)(courier_s);
      __serviceid = request; 
      println@Console(__serviceid + ": Courier written on local File with Name: " + __serviceid + "Courier.ol")();
      with (filereq) {
         .content = courier_s;
         .filename = "couriers/"+__serviceid +"Courier.ol"
      };
      writeFile@File(filereq)();
      __newcourierredirection;
      println@Console(__serviceid + ": SUCCESS")()
  }]
}