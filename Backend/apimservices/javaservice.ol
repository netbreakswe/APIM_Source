include "interfaces/javainterface.iol"

execution { concurrent }


outputPort JavaExecutable {
	Interfaces: JavaInterface
}

inputPort JolieporttoClient {
	Location: "socket://localhost:8310"
	Protocol: http { 
		//Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins.
		.response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
		.response.headers.("Access-Control-Allow-Origin") = "*";
		.response.headers.("Access-Control-Allow-Headers") = "Content-Type"
	}
	Interfaces: JavaInterface
}

embedded {
	Java: "test.Jolietest" in JavaExecutable
}
//jolietest.jar contiene test::Jolietest:
//package test;
//import jolie.runtime.JavaService;
//public class Jolietest extends JavaService{
    //public String getA() {
        //return "A";
    //}
    //public String getB() {
        //return "B";
    //}
    //public String getC() {
        //return "C";
    //}
//}

main
{
	[getA( request )( result ) {
		getA@JavaExecutable(request)(result)
	}]
	[getB( request )( result ) {
		getB@JavaExecutable(request)(result)
	}]
	[getC( request )( result ) {
		getC@JavaExecutable(request)(result)
	}]


}