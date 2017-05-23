/*Singolo endpoint per i file:
Siccome e' il 2017 non e' appropriato salvare i file localmente, ma e' meglio salvare su cloud per avere 
una gestione generale dei file. In pratica per ogni form che richiede caricamento, appena selezioni il file 
(immagine o pdf), una funzione asincrona, tramite post, inizia il caricamento in background solo del file, 
ritornando l'uri del file al client. Mentre il file viene caricato, l'utente puo' compilare il resto, senza 
aspettare che sia fatto tutto quando il form intero e' completo. Questo permetterebbe di aggiungere in un unico 
posto eventuali funzioni per il resize delle immagini e in caso l'utente carica un immagine e poi spegne il 
browser (quindi sull'endpoint avrei garbage di quell'immagine caricata e non associata a niente) fare una volta 
ogni x giorni un garbage collector che elimina questi eventuali garbage (per ora senza implementazione). 
Questo fa si' che ogni singolo servizio che fa fetch di dati, non sia ogni volta appesantito anche per scaricare 
file pdf o altro del tipo*/

include "console.iol"
include "file.iol"
include "database.iol"
include "string_utils.iol"
include "protocols/http.iol"
include "time.iol"

include "interfaces/filehandlerinterface.iol"

execution { concurrent }

outputPort Self {
	Protocol: http 
	Location: "socket://localhost:8004/"
	Interfaces: FileHandlerInterface
}

inputPort FileHandler {
	Protocol: http {
		.format = "json";
		.keepAlive = true; // Keep connections open
		.debug = DebugHttp; 
		.debug.showContent = DebugHttpContent;
		.contentType -> mime;
		.statusCode -> statusCode;
		.response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
		.response.headers.("Access-Control-Allow-Origin") = "*";
		.response.headers.("Access-Control-Allow-Headers") = "Content-Type"
	}
	Location: "socket://localhost:8004/"
	Interfaces: FileHandlerInterface
}

/*1. Procedura private per aggiungere metadati di un file al db. Non ha senso esporla all'esterno*/
define __saveFileMetadata {
  q = "INSERT INTO files(Filename, Size) VALUES (:filename, :size)";
  q.filename = _filename;
  q.size = _size;
  update@Database( q )( result )
}

init
{
  println@Console( "Filehandler started" )();
  //connect to microservices database
  with( connectionInfo ) {
      .host = "u3y93bv513l7zv6o.chr7pe7iynqr.eu-west-1.rds.amazonaws.com"; 
      .driver = "mysql";
      .port = 3306;
      .database = "loknuaspq2gzm0t0";
      .username = "ski72gl6hwma8uve";
      .password = "yl4wccr7zfo1gvbz"
    };
    connect@Database( connectionInfo )();
    println@Console("DB connected, connection is running on host:" + connectionInfo.host )()
}



main
{







	/*controlla se il filename scelto esiste nel db*/
	[ filenameExists( request )( response ) {
		q = "select * from files where Filename = :filename";
	    q.filename = request.filename;
	    query@Database( q )( result );
	    response = true;
	    if (#result.rows == 0) {
	    	response = false
	    }
	}]










	/*riceve un file e lo salva localmente con filename univoco e ritorna l'uri del file al chiamante*/
	[ setFile( request )( response ) {
		/*genera stringa random con possibilita' quasi nulla di averne di identiche*/
		getRandomUUID@StringUtils()( random );
		getDateTime@Time(0)( time );
		getSize@File( request.file )( size );
		randomname = random+time.day+time.hour+time.year+time.month+time.second+"."+request.extension;
		with (file) {
			.filename = "../../../Frontend/app/images/uploaded_images/"+randomname; //unique filename
			.format = "binary";
			.content -> request.file
		};
		/*controllo se filename gia' esistente*/
		filenameExists@Self(file.filename)(exists);
		println@Console("filename: "+file.filename+ " esiste gia' queste filename? "+exists)();
		if (!exists) {
			/*se no salvalo nel db e localmente e fornisci l'uri al chiamante*/
			_filename = randomname;
			_size = size/100;
			__saveFileMetadata;
		    writeFile@File( file )();
			response = randomname
		}
	}]
}
