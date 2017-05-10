include "interfaces/profileinterfaceC.iol"
include "console.iol"

/*client per provare ProfileService, con id = 6, composto da: 
    composto da 
    -[0]subservice: profileservice.ol
        -[0]interface: profileinterface.iol 
*/

main {
    r = void;
    with( r ) {
        .key = "1111"
    };
    getUsers@ProfileService( r )(rs);
    for (i = 0, i < #rs.persona, i++) {
      println@Console(rs.persona[i].nome)(); //stampa nome i
      println@Console(rs.persona[i].cognome)() //stampa cognome i
    }
}
