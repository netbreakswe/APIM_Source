include "interfaces/calc_interfaceC.iol"
include "console.iol"

/*client per provare CalcService, con id = 1, composto da:
    -[0]subservice: calcservice.ol
        -[0]interface: calc_divinterface.iol
        -[1]interface: calc_subinterface.iol
        -[2]interface: calc_suminterface.iol
*/

main {
    with( op ) {
        .a = 5;
        .b = 7;
        .key = "1111"
    };
    sum@CalcService_43( op )(rs1);
    sumanddouble@CalcService_43( op )(rs2);
    sub@CalcService_43( op )(rs3);
    subanddouble@CalcService_43( op )(rs4);
    div@CalcService_43( op )(rs5);
    divanddouble@CalcService_43( op )(rs6);
    println@Console(rs1)();
    println@Console(rs2)();
    println@Console(rs3)();
    println@Console(rs4)();
    println@Console(rs5)();
    println@Console(rs6)()
}