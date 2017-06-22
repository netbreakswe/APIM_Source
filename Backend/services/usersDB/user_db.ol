include "interfaces/user_dbInterface.iol"

include "database.iol"
include "console.iol"
include "string_utils.iol"
include "time.iol"


execution { sequential }


// basta questa port per comunicare con tutti i servizi
inputPort user_dbJSONInput {
  Location: "socket://localhost:8101"
  Protocol: http { 
  	// Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins
  	.response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
    .response.headers.("Access-Control-Allow-Origin") = "*";
    .response.headers.("Access-Control-Allow-Headers") = "Content-Type, Authorization";
  	.format = "json"
  }
  Interfaces: user_dbInterface
}

// 1. Procedura che controlla se esiste mail
define __mail_exists {
	q_SLAWP4I = "SELECT * FROM clients WHERE Email=:email";
	q_SLAWP4I.email = __email_SLAWP4I;
	query@Database( q_SLAWP4I )( result_SLAWP4I );
	// se non lo trova vuol dire che non esiste
	if ( #result_SLAWP4I.row == 0 ) {
    	println@Console("Client not found")();
    	__mail_exists_confirmed = false
  	}
  	// altrimenti esiste
  	else {
    	println@Console("Email exists with info " + __email_SLAWP4I)();
    	__mail_exists_confirmed = true
  	}
}

// 2. Da fare procedura privata per controllare se un utente che fa certa op sia admin o no 
// (solo admin possono fare certe operazioni tipo la moderazione)

init
{
    println@Console( "User Db Microservice started" )();

  	//connect to user database (heroku)
  	with( connectionInfo ) {
  		.host = "jfrpocyduwfg38kq.chr7pe7iynqr.eu-west-1.rds.amazonaws.com"; 
      	.driver = "mysql";
      	.port = 3306;
      	.database = "y4ptgfl1v301bz2r";
      	.username = "irb775yk0nhfmus9";
      	.password = "l1bgy7nlgdd0mn7j"
    };
    connect@Database( connectionInfo )();
    println@Console("DB connected, connection is running on host:" + connectionInfo.host)()
}


main
{
	

	  // in seguito al login verifica se l'utente autenticato esista come cliente/developer e se si ritorna true
  	[user_exists( request )( response ) {

  		// query
    	q = "SELECT * FROM clients WHERE Email=:email AND Password=:password";
    	q.email = request.Email;
    	q.password = request.Password;
    	query@Database( q )( result );

    	// se non lo trovi vuol dire che non esiste
    	if ( #result.row == 0 ) {
      		println@Console("Client not found")();
     		response = false
    	}
    	// altrimenti esiste
    	else {
      		println@Console("Client exists with info " + request.Email + " " + request.Password)();
      		response = true
    	}

  	}]

    // in seguito al login verifica se l'admin autenticato esista e se si ritorna true
    [admin_exists( request )( response ) {

      // query
      q = "SELECT * FROM admins WHERE Email=:email AND Password=:password";
      q.email = request.Email;
      q.password = request.Password;
      query@Database( q )( result );

      // se non lo trovi vuol dire che non esiste
      if ( #result.row == 0 ) {
          println@Console("Client not found")();
        response = false
      }
      // altrimenti esiste
      else {
          println@Console("Client exists with info " + request.Email + " " + request.Password)();
          response = true
      }

    }]


  	// recupera tutte le info di base di un admin
  	[retrieve_admin_info( request )( response ) {

    	// query
    	q = "SELECT * FROM admins WHERE IdAdmin=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Admin not found")()
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got admin " + result.row[i].Name )();
        		response << result.row[i]
      		}
   		};
    	println@Console("Retrieved info about admin " + response.Name + " " + response.Surname)()

  	}]


    // recupera tutte le info di base di un admin
    [retrieve_admin_info_from_email( request )( response ) {

      // query
      q = "SELECT * FROM admins WHERE Email=:m";
      q.i = request.Id;
      query@Database( q )( result );

      if ( #result.row == 0 ) {
          println@Console("Admin not found")()
      }
      else {
          for ( i=0, i<#result.row, i++ ) {
            println@Console( "Got admin " + result.row[i].Name )();
            response << result.row[i]
          }
      };
      println@Console("Retrieved info about admin " + response.Name + " " + response.Surname)()

    }]


  	// ritorna tutte le info di un cliente/developer sulla base del suo id
  	[retrieve_client_info( request )( response ) {

    	// query
   		q = "SELECT * FROM clients WHERE IdClient=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Client not found")()
    	}
    	else {
     		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got client " + result.row[i].Name )();
        		response << result.row[i]
      		}
    	};
    	println@Console("Retrieved info about client " + response.Name + " " + response.Surname)()

  	}]

    // ritorna tutte le info di un cliente/developer sulla base del suo id
    [retrieve_all_dev_info( request )( response ) {

      // query
      q = "SELECT * FROM clients WHERE ClientType = 2";
      q.i = request.Id;
      query@Database( q )( result );

      println@Console(q)();

      if ( #result.row == 0 ) {
          println@Console("Client not found")()
      }
      else {
        // scorre righe del risultato
        for( i=0, i<#result.row, i++ ) {

            s_i = #response.users; // ricava l'indice dove inserire il nuovo servizio
            response.users[s_i].IdClient = result.row[i].IdClient;
            response.users[s_i].Name = result.row[i].Name;
            response.users[s_i].Surname = result.row[i].Surname;
            response.users[s_i].Email = result.row[i].Email;
            response.users[s_i].Password = result.row[i].Password;
            response.users[s_i].Avatar = result.row[i].Avatar;
            response.users[s_i].Credits = result.row[i].Credits;
            response.users[s_i].ClientType = result.row[i].ClientType;
            response.users[s_i].Registration = result.row[i].Registration;
            response.users[s_i].AboutMe = result.row[i].AboutMe;
            response.users[s_i].Citizenship = result.row[i].Citizenship;
            response.users[s_i].LinkToSelf = result.row[i].LinkToSelf;
            response.users[s_i].PayPal = result.row[i].PayPal

        }
      };
      println@Console("Retrieved info about all client" )()

    }]



  /*  // ritorna tutte le info di un cliente sulla base di un subset di id
    [retrieve_all_client_info_from_id_subset( request )( response ) {

      // query
      //q = "SELECT * FROM clients WHERE IdClient=:i";
      q = "SELECT * FROM clients WHERE IdClient IN ";
      //q.i = request.Id;

      IdListClient = "(" + request.clientidlist[0].id;
      for ( j=1, j<request.length, j++ ) {
         IdListClient = IdListClient + " , " + request.clientidlist[j].id
      };
      IdListClient  = IdListClient + " )" ;

      println@Console(IdListClient)();

      q = q + IdListClient;

      println@Console(q)();

      query@Database( q )( result );

      if ( #result.row == 0 ) {
          println@Console("Client not found")()
      }
      else {
        for ( i=0, i<#result.row, i++ ) {
            println@Console( "Got client " + result.row[i].Name )();
            response << result.row[i];
            println@Console("Retrieved info about client " + response.Name + " " + response.Surname)()
          }
      }

    }]
*/



  	// ritorna tutte le info di un utente partendo dalla sua email
  	[retrieve_client_info_from_email( request )( response ) {

    	// query
    	q = "SELECT * FROM clients WHERE Email=:m";
    	q.m = request.Email;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Client not found")()
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got client "+ result.row[i].Name )();
        		response << result.row[i]
      		}
    	};
    	println@Console("Retrieved info about client with email " + request.Email)()

  	}]




  	// ritorna nome e cognome di un cliente
  	[retrieve_client_anagraphics( request )( response ) {

    	// query
    	q = "SELECT Name,Surname FROM clients WHERE IdClient=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Client not found")()
    	}
    	else {
      		println@Console( "Got Client " + result.row[0].Name + " " + result.row[0].Surname )();
      		response.Name = result.row[0].Name;
          response.Surname = result.row[0].Surname;
          response.IdUser = request.Id
    	};
    	println@Console("Retrieved anagraphics about client " + response.Name + " " + response.Surname)()

  	}]




  	// ritorna la tipologia di un cliente
  	[retrieve_client_type( request )( response ) {

    	// query
    	q = "SELECT ClientType FROM clients WHERE IdClient=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("ClientType not found")()
    	}
    	else {
      		println@Console( "Got ClientType " + result.row[0].ClientType )();
      		response.ClientType = result.row[0].ClientType
    	};
    	println@Console("Retrieved client type " + response.ClientType)()

  	}]




   	// recupera tutte le info della moderazione
  	[retrieve_moderation_info( request )( response ) {

    	// query
    	q = "SELECT * FROM moderationlog WHERE IdEntry=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Moderation entry not found")()
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got moderation entry " + result.row[i].IdEntry )();
        		response << result.row[i]
      		}
    	};
    	println@Console("Retrieved entry " + response.IdEntry)()

  	}]




  	// ritorna tutti i tipi di moderazione
  	[retrieve_modtype_info( request )( response ) {

    	// query
    	q = "SELECT * FROM moderationtypes WHERE IdModType=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Moderation type not found")()
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        	println@Console( "Got moderation type " + result.row[i].IdModType )();
        	response << result.row[i]
      		}
    	};
    	println@Console("Retrieved moderation type " + response.IdModType)()

  	}]




  	// recupera tutte le info relative a un cliente
  	[retrieve_clienttype_info( request )( response ) {

    	// query
    	q = "SELECT * FROM clienttypes WHERE IdClientType=:i";
    	q.i = request.Id;
    	query@Database( q )( result );

    	if ( #result.row == 0 ) {
      		println@Console("Client type not found")()
    	}
    	else {
      		for ( i=0, i<#result.row, i++ ) {
        		println@Console( "Got client type " + result.row[i].IdClientType )();
        		response << result.row[i]
      		}
    	};
    	println@Console("Retrieved client type " + response.Name)()

  	}]




    // ritorna tutti gli id dei developers
    [retrieve_all_devid( request )( response ) {

      // query
      q = "SELECT IdClient FROM clients WHERE ClientType=2";
      query@Database( q )( result );

      if ( #result.row == 0 ) {
          println@Console("Developers not found")()
      }
      else {
          for ( i=0, i<#result.row, i++ ) {
            println@Console( "Got developer "+ result.row[i].IdClient )();
            response.devidlist[i].Id = result.row[i].IdClient
          }
      };
      println@Console("Retrieved all developers id")()

    }]




  	// registrazione di un utente ad apim
  	[basicclient_registration( request )( response ) {

    	__email_SLAWP4I = request.Email;
    	__mail_exists; // controllo se mail esiste già
    	if (!__mail_exists_confirmed) {
          println@Console("Basicclient_registration execution started")();
      		getCurrentDateValues@Time( void )( currdate ); // data corrente

          length@StringUtils( string(currdate.day) )( dayl );
          if( dayl == 1 ) {
            currdate.day = "0" + string(currdate.day)
          };

          length@StringUtils( string(currdate.month) )( monthl );
          if( monthl == 1 ) {
            currdate.month = "0" + string(currdate.month)
          };

      		// query
      		q = "INSERT INTO clients (IdClient,Name,Surname,Email,Password,Avatar,Registration,Credits,ClientType,AboutMe,Citizenship,LinkToSelf,PayPal) 
           		VALUES (:idclient,:nome,:cognome,:email,:password,:avataruri,:regdate,100,1,:aboutme,:cittadinanza,:linkweb,:paypal)";
        	with( q ) {
        		.idclient = request.IdClient;
	          .nome = request.Name;
	          .cognome = request.Surname;
	          .email = request.Email;
	          .password = request.Password;
	          .avataruri = request.Avatar;
	          .regdate = currdate.day + "/" + currdate.month + "/" + currdate.year;
	          .aboutme = request.AboutMe;
	          .cittadinanza = request.Citizenship;
	          .linkweb = request.LinkToSelf;
	          .paypal = request.PayPal
      		};
     		  update@Database( q )( result );
      		response = true // l'utente non esiste ed è stato creato
    	} 
    	else {
      	response = false // l'utente esiste pertanto non è stato creato
    	}

  	}]




  	// upgrade cliente basic a developer
  	[developer_upgrade( request )( response ) {

    	// query
    	q = "UPDATE clients SET ClientType=2,Credits=Credits-1000 WHERE IdClient=:i";
    	with( request ) {
      	q.i = .Id
    	};
    	update@Database( q )( result );
    	println@Console("Upgrading basic client with id " + request.IdClient + " to developer status")()

  	}]




  	// downgrade developer a cliente basic
  	[basicclient_downgrade( request )( response ) {

    	// query
   		q = "UPDATE clients SET ClientType=1,AboutMe='',Citizenship='',LinkToSelf='',PayPal='' WHERE IdClient=:i";
    	with( request ) {
      	q.i = .Id
    	};
    	update@Database( q )( result );
    	println@Console("Downgrading developer with id " + request.Id + " to basic client status")()

  	}]




  	// apporta moderazione ad un cliente
  	[client_moderation( request )( response ) {

    	// query
    	q = "INSERT INTO moderationlog (IdClient,IdAdmin,Timestamp,ModType,Report) VALUES (:ic,:ia,:t,:mt,:r)";
    	with( request ) {
      	q.ic = .IdClient;
		    q.ia = .IdAdmin;
		    q.t = .Timestamp;
		    q.mt = .ModType;
		    q.r = .Report
    	};
    	update@Database( q )( result );
    	println@Console("Creating new moderation entry")()

  	}]




    // aggiorna i dati di un cliente
    [client_password_change( request )( response ) {

      // query
      q = "UPDATE clients SET Password=:p WHERE IdClient=:i";
      with( request ) {
        q.i = .IdClient;
        q.p = .Password
      };
      update@Database( q )( result );
      println@Console("Changing password of user with id " + request.IdClient)()

    }]




  	// aggiorna i dati di un cliente
  	[client_update( request )( response ) {

  		// query
    	q = "UPDATE clients SET Name=:n,Surname=:s,Email=:e,Avatar=:a,AboutMe=:am,Citizenship=:ct,LinkToSelf=:l,PayPal=:pp WHERE IdClient=:i";
    	with( request ) {
	    	q.i = .IdClient;
	      q.n = .Name;
	      q.s = .Surname;
	      q.e = .Email;
	      q.a = .Avatar;
	     	q.am = .AboutMe;
	      q.ct = .Citizenship;
	      q.l = .LinkToSelf;
	      q.pp = .PayPal
    	};
    	update@Database( q )( result );
    	println@Console("Updating user profile with id " + request.IdClient)()

  	}]




  	// elimina un cliente
  	[client_delete( request )( response ) {

    	// query
    	q = "DELETE FROM clients WHERE IdClient=:i";
    	with( request ) {
      	q.i = .Id
    	};
    	update@Database( q )( result );
    	println@Console("Deleting client with id " + request.Id + " forever")()

  	}]




    // aggiornamento crediti di un cliente
    [credits_update( request )( response ) {

      // query
      q = "UPDATE clients SET Credits = Credits + :c WHERE IdClient=:i";
      with( request ) {
        q.i = .IdClient;
        q.c = .Credits
      };
      update@Database( q )( result );
      println@Console("Updated credits of client with id " + request.IdClient + " by the amount of " + request.Credits )()

    }]



}