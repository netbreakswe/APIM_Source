include "interfaces/javainterfaceC.iol"
include "console.iol"

/*client per provare JavaService, con id = 5, composto da: 
    composto da 
    -[0]subservice: javaservice.ol
        -[0]interface: javainterface.iol 
*/

main {
    r = void;
    with( r ) {
        .key = "1111"
    };
    getA@JavaService( r )(rs1);
    getB@JavaService( r )(rs2);
    getC@JavaService( r )(rs3);
    println@Console(rs1)();
    println@Console(rs2)();
    println@Console(rs3)()
}