include "database.iol"
include "json_utils.iol"
include "interfaces/profileinterface.iol"


execution { concurrent }

inputPort ProfileService {
	Location: "socket://localhost:8030"
	Protocol: http { 
		.format = "json";
		//Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins.
		.response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
		.response.headers.("Access-Control-Allow-Origin") = "*";
		.response.headers.("Access-Control-Allow-Headers") = "Content-Type"

	}
	Interfaces: ProfileInterface
}

init {
	with ( connectionInfo ) {
		//my db mysql location
		.host = "u3y93bv513l7zv6o.chr7pe7iynqr.eu-west-1.rds.amazonaws.com";
		.driver = "mysql"; //specify driver as in Java, located in lib
		.port = 3306;
        .database = "c4hulgnohm4ago42"; 
        .username = "wshsplbxfb58lde3";
        .password = "b5qe1ptcej9pt3w7"
    };
    connect@Database( connectionInfo )( void )

}

main
{
	[getUsers( void )( result ) {	
		query@Database(
			"select * from nomecognome"
		)(sqlResponse);
		i = 0;
		while (i < #sqlResponse.row) {
			persone.persona[i].nome = sqlResponse.row[i].nome;	
		    persone.persona[i].cognome = sqlResponse.row[i].cognome;	
			i++
		};
		result -> persone

	}]
	[ insertUser(request)(response) {
		update@Database(
			"insert into nomecognome(nome, cognome) values (:nome, :cognome)" {
				.nome = request.nome,
				.cognome = request.cognome
			}
		)(response.status)
	} ]
}
    
