include "interfaces/user_dbInterface.iol"

include "database.iol"
include "console.iol"
include "time.iol"

execution { sequential }


/*basta questa port per comunicare con tutti i servizi*/
inputPort user_dbJSONInput {
  Location: "socket://localhost:8101"
  Protocol: http { 
  	//Access-Control-Allow-Origin response header to tell the browser that the content of this page is accessible to certain origins
		.response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
		.response.headers.("Access-Control-Allow-Origin") = "*";
		.response.headers.("Access-Control-Allow-Headers") = "Content-Type";
  	.format = "json"
  	}
  Interfaces: user_dbInterface
}

/*1. Procedura che controlla se esiste mail*/
define __mail_exists {
  q_SLAWP4I = "SELECT * FROM clients WHERE Email=:email;";
  q_SLAWP4I.email = __email_SLAWP4I;
  query@Database( q_SLAWP4I )( result_SLAWP4I );
  //se non lo trovi vuol dire che non esiste
  if ( #result_SLAWP4I.row == 0 ) {
    println@Console("Client not found")();
    __mail_exists_confirmed = false
  }
  //altrimenti esiste
  else {
    println@Console("Email exists with info " + __email_SLAWP4I)();
    __mail_exists_confirmed = true
  }
}
/*****************************************************************/

/*2. fare procedura privata per controllare se un utente che fa certa op e' admin o no. 
(solo admin possono fare certe operazioni tipo la moderazione)*/


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
    println@Console("DB connected, connection is running on host:" + connectionInfo.host )()
}

main
{






  //in seguito al login verifica se l'utente autenticato esiste come cliente/developer e se si ritorna true
  [user_exists( request )( response ) {
    //cerca gli utenti con queste credenziali
    q = "SELECT * FROM clients WHERE Email=:email AND Password=:password";
    q.email = request.Email;
    q.password = request.Password;
    query@Database( q )( result );
    //se non lo trovi vuol dire che non esiste
    if ( #result.row == 0 ) {
      println@Console("Client not found")();
      response = false
    }
    //altrimenti esiste
    else {
      println@Console("Client exists with info " + request.Email + " " + request.Password)();
      response = true
    }
  }]








  //recupera tutte le info di base di un admin
  [retrieve_admin_info( request )( response ) {

    //query
    q = "SELECT * FROM admins WHERE IdAdmin=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if ( #result.row == 0 ) {
      println@Console("Admin not found")()
    }
    else {
      for ( i=0, i<#result.row, i++ ) {
        println@Console( "Got admin "+ result.row[i].Name )();
        response << result.row[i]
      }
    };
    println@Console("Retrieved info about admin " + response.Name + " " + response.Surname)()
  }]










  //ritorna tutte le info di un cliente/developer sulla base del suo id
  [retrieve_client_info( request )( response ) {

    //query
    q = "SELECT * FROM clients WHERE IdClient=:i";
    q.i = request.Id;
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
    println@Console("Retrieved info about client " + response.Name + " " + response.Surname)()
  }]









  //ritorna tutte le info di un cliente/developer sulla base della sua mail
  [retrieve_client_info_by_mail( request )( response ) {
    //query
    q = "SELECT * FROM clients WHERE Email=:m";
    q.m = request.Mail;
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
    println@Console("Retrieved info about client " + response.Name + " " + response.Surname)()
  }]








  //ritorna la tipologia di un cliente
  [retrieve_client_type( request )( response ) {

    //query
    q = "SELECT ClientType FROM clients WHERE IdClient=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if ( #result.row == 0 ) {
      println@Console("ClientType not found")()
    }
    else {
      println@Console( "Got ClientType "+ result.row[0].ClientType )();
      response.ClientType = result.row[0].ClientType
    };
    println@Console("Retrieved client type " + response.ClientType)()
  }]







   //recupera tutte le info della moderazione
  [retrieve_moderation_info( request )( response ) {
    //query
    q = "SELECT * FROM moderationlog WHERE IdEntry=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if ( #result.row == 0 ) {
      println@Console("Moderation entry not found")()
    }
    else {
      for ( i=0, i<#result.row, i++ ) {
        println@Console( "Got moderation entry "+ result.row[i].IdEntry )();
        response << result.row[i]
      }
    };
    println@Console("Retrieved entry " + response.IdEntry)()
  }]









  //ritorna tutti i tipi di moderazione
  [retrieve_modtype_info( request )( response ) {
    //query
    q = "SELECT * FROM moderationtypes WHERE IdModType=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if ( #result.row == 0 ) {
      println@Console("Moderation type not found")()
    }
    else {
      for ( i=0, i<#result.row, i++ ) {
        println@Console( "Got moderation type "+ result.row[i].IdModType )();
        response << result.row[i]
      }
    };
    println@Console("Retrieved moderation type " + response.IdModType)()
  }]









  //recupera tutte le info relative a un cliente
  [retrieve_clienttype_info( request )( response ) {

    //query
    q = "SELECT * FROM clienttypes WHERE IdClientType=:i";
    q.i = request.Id;
    query@Database( q )( result );

    if ( #result.row == 0 ) {
      println@Console("Client type not found")()
    }
    else {
      for ( i=0, i<#result.row, i++ ) {
        println@Console( "Got client type "+ result.row[i].IdClientType )();
        response << result.row[i]
      }
    };
    println@Console("Retrieved client type " + response.Name)()
  }]








  //registrazione di un utente ad apim
  [basicclient_registration( request )( response ) {
    __email_SLAWP4I = request.Email;
    __mail_exists; //controllo se mail esiste gia'
    if (!__mail_exists_confirmed) {
      println@Console("basicclient_registration execution started")();
      getDateTime@Time( 0 )( date ); //data corrente
      //query
      q = "INSERT INTO clients (Name,Surname,Email,Password,Avatar,Registration,
           Credits,ClientType,AboutMe,Citizenship,LinkToSelf,PayPal) 
           VALUES (:nome, :cognome, :email, :password, :avataruri, :regdate, 100, 
           1, :aboutme, :cittadinanza, :linkweb, :paypal)";
        with( q ) {
            .nome = request.Name;
            .cognome = request.Surname;
            .email = request.Email;
            .password = request.Password;
            .avataruri = request.Avatar;
            .regdate = date.year + "-" + date.month + "-" + date.day;
            .aboutme = request.AboutMe;
            .cittadinanza = request.Citizenship;
            .linkweb = request.LinkToSelf;
            .paypal = request.PayPal
      };
      update@Database( q )( result );
      response = false; //utente non esiste ed e' stato creato
      println@Console("Registering new basic client " + request.Name + " " + request.Surname)()
    } else {
      response = true //utente esiste pertanto non e' stato creato
    }
  }]











  //cliente diventa developer
  [developer_upgrade( request )( response ) {

    //query
    q = "UPDATE clients SET ClientType=2,AboutMe=:am,Citizenship=:c,LinkToSelf=:l,PayPal=:pp WHERE IdClient=:i";
    with( request ) {
      q.i = .IdClient;
      q.am = .AboutMe;
      q.c = .Citizenship;
      q.l = .LinkToSelf;
      q.pp = .PayPal
    };
    update@Database( q )( result );
    println@Console("Upgrading basic client with id " + request.IdClient +" to developer status")()
  }]









  //riduci un developer a cliente
  [basicclient_downgrade( request )( response ) {

    //query
    q = "UPDATE clients SET ClientType=1,AboutMe='',Citizenship='',LinkToSelf='',PayPal='' WHERE IdClient=:i";
    with( request ) {
      q.i = .Id
    };
    update@Database( q )( result );
    println@Console("Downgrading developer with id " + request.Id +" to basic client status")()
  }]









  //apporta moderazione a cliente
  [client_moderation( request )( response ) {

    //query
    q = "INSERT INTO moderationlog (IdClient,IdAdmin,Timestamp,ModType,Report) 
      VALUES (:ic,:ia,:t,:mt,:r)";
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












  //aggiorna dati cliente
  [client_update( request )( response ) {
    q = "UPDATE clients 
      SET Name=:n,Surname=:s,Email=:e,Password=:p,Avatar=:a,Credits=:c,AboutMe=:am,Citizenship=:ct,LinkToSelf=:l,PayPal=:pp 
      WHERE IdClient=:i";
    with( request ) {
      q.i = .IdClient;
      q.n = .Name;
      q.s = .Surname;
      q.e = .Email;
      q.p = .Password;
      q.a = .Avatar;
      q.c = .Credits;
      q.am = .AboutMe;
      q.ct = .Citizenship;
      q.l = .LinkToSelf;
      q.pp = .PayPal
    };
    update@Database( q )( result );
    println@Console("Updating user profile with id " + request.IdClient)()
  }]






  //elimina cliente i
  [client_delete( request )( response ) {

    //query
    q = "DELETE FROM clients WHERE IdClient=:i";
    with( request ) {
      q.i = .Id
    };
    update@Database( q )( result );
    println@Console("Deleting client with id " + request.Id +" forever")()
  }]
}