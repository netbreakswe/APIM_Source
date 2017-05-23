include "interfaces/CommService_11.iol"
include "console.iol"

/*client per provare InteractionService, con id = 4, composto da:
    -[0]subservice: commservice.ol
        -[0]interface: faxinterface.iol
        -[1]interface: mailinterface.iol
    -[1]helloservice.ol
        -[0]interface: hellointerface.iol
   N.B. per provare avviare sia commservice.ol che helloservice.ol in terminali separati
*/

main {
    /*begin dati prova per richiesta*/
    with( rq_fax ) {
        .key = "1111";
        .destination = "dan";
        .content = "contenuto fax per dan..."
    };
    fax@CommService_11( rq_fax )(rs);
    faxwithnoresponse@CommService_11( rq_fax );

    with( rq_mail ) {
        .key = "1111";
        .mail = "tulliosuccaD@blackpower.sex";
        .content = "contenuto fax per Johnson..."
    };
    mail@CommService_11( rq_mail )(rsl);
    mailwithnoresponse@CommService_11( rq_mail );

    println@Console("Print 1")();
    println@Console(rsl)();
    println@Console("Print 2")();
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
    sayhello@CommService_11( req1 )(rs1);
    saysuperhello@CommService_11( req1 )(rs2);
    sayagreeting@CommService_11( req2 )(rs3);
    /*end richieste*/

    /*begin stampa risultati richieste*/
    println@Console("Print 3")();
    println@Console(rsl)();
    println@Console("Print 4")();
    println@Console(rs)()
    /*end stampa risultati richieste*/


}
