include "interfaces/javainterface.iol"
include "console.iol"

outputPort JavaService {
	Location: "socket://localhost:9004"
	Protocol: sodep
	Interfaces: JavaInterface
}

main {
    getA@JavaService()(rs1);
    getB@JavaService()(rs2);
    getC@JavaService()(rs3);
    println@Console(rs1)();
    println@Console(rs2)();
    println@Console(rs3)()
}