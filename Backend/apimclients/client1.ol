include "interfaces/interactioninterfaceC.iol"
include "console.iol"

/*client per provare InteractionService, con id = 4, composto da:
    -[0]subservice: faxservice.ol
        -[0]interface: faxinterface.iol
        -[1]interface: mailinterface.iol
    -[1]helloservice.ol
        -[0]interface: hellointerface.iol
   N.B. per provare avviare sia faxservice.ol che helloservice.ol in terminali separati
*/

main {
    /*begin dati prova per richiesta*/
    with( rq_fax ) {
        .key = "1111";
        .destination = "dan";
        .content = "contenuto fax per dan..."
    };
    fax@InteractionService( rq_fax )(rs);
    faxwithnoresponse@InteractionService( rq_fax );

    with( rq_mail ) {
        .key = "1111";
        .mail = "tulliosuccaD@blackpower.sex";
        .content = "contenuto fax per Johnson..."
    };
    mail@InteractionService( rq_mail )(rsl);
    mailwithnoresponse@InteractionService( rq_mail );

    println@Console(rsl)();
    println@Console(rs)();
    req1 = "dan";
    with( req1 ) {
        .key = "1111"
    };
    req2 = 12;
    with( req2 ) {
        .key = "1111"
    };
    /*end dati prova per richiesta*/

    /*begin richieste*/
    sayhello@InteractionService( req1 )(rs1);
    saysuperhello@InteractionService( req1 )(rs2);
    sayagreeting@InteractionService( req2 )(rs3);
    /*end richieste*/

    /*begin stampa risultati richieste*/
    println@Console(rs1)();
    println@Console(rs2)();
    println@Console(rs3)()
    /*end stampa risultati richieste*/


}
