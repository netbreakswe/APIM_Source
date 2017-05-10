-- --------------------------------------------------------
-- Host:                         apimusersinstance.ccsrygwsp8kn.eu-west-2.rds.amazonaws.com
-- Versione server:              5.7.16-log - MySQL Community Server (GPL)
-- S.O. server:                  Linux
-- HeidiSQL Versione:            9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dump della struttura del database UsersDB
CREATE DATABASE IF NOT EXISTS `UsersDB` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `UsersDB`;

-- Dump della struttura di tabella UsersDB.admins
CREATE TABLE IF NOT EXISTS `admins` (
  `IdAdmin` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Surname` varchar(20) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Password` varchar(20) NOT NULL,
  PRIMARY KEY (`IdAdmin`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella UsersDB.admins: ~2 rows (circa)
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` (`IdAdmin`, `Name`, `Surname`, `Email`, `Password`) VALUES
	(1, 'Marco', 'Casagrande', 'marco.casagrande.5@studenti.unipd.it', 'skitinudo'),
	(2, 'Davide', 'Scarparo', 'davide.scarparo@studenti.unipd.it', 'viafasulla99');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;

-- Dump della struttura di tabella UsersDB.clients
CREATE TABLE IF NOT EXISTS `clients` (
  `IdClient` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Surname` varchar(20) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Password` varchar(20) NOT NULL,
  `Avatar` varchar(50) NOT NULL,
  `Registration` date NOT NULL,
  `Credits` int(11) NOT NULL,
  `ClientType` int(11) NOT NULL,
  `AboutMe` text NOT NULL,
  `Citizenship` varchar(20) NOT NULL,
  `LinkToSelf` varchar(20) NOT NULL,
  `PayPal` varchar(19) NOT NULL,
  PRIMARY KEY (`IdClient`),
  KEY `ClientType` (`ClientType`),
  CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`ClientType`) REFERENCES `clienttypes` (`IdClientType`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella UsersDB.clients: ~2 rows (circa)
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` (`IdClient`, `Name`, `Surname`, `Email`, `Password`, `Avatar`, `Registration`, `Credits`, `ClientType`, `AboutMe`, `Citizenship`, `LinkToSelf`, `PayPal`) VALUES
	(1, 'Dan', 'Ser', 'ds@gmail.com', 'danser', 'http://avatarfigo.com', '2017-03-08', 300, 1, 'Sono Dan Ser', 'Non lo so', 'http://danser.com', '1111-2222-3333-4444'),
	(2, 'Andrea', 'Scalabrin', 'andrea.scalabrin@gmail.com', 'faccioilcss', 'https://pistolanelcassetto.it', '2017-04-02', 0, 2, '', '', '', '');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;

-- Dump della struttura di tabella UsersDB.clienttypes
CREATE TABLE IF NOT EXISTS `clienttypes` (
  `IdClientType` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Description` varchar(50000) NOT NULL,
  PRIMARY KEY (`IdClientType`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella UsersDB.clienttypes: ~2 rows (circa)
/*!40000 ALTER TABLE `clienttypes` DISABLE KEYS */;
INSERT INTO `clienttypes` (`IdClientType`, `Name`, `Description`) VALUES
	(1, 'Basic', 'The basic client can buy any API in the market'),
	(2, 'Developer', 'The developer can register his own APIs on the market');
/*!40000 ALTER TABLE `clienttypes` ENABLE KEYS */;

-- Dump della struttura di tabella UsersDB.moderationlog
CREATE TABLE IF NOT EXISTS `moderationlog` (
  `IdEntry` int(11) NOT NULL AUTO_INCREMENT,
  `IdClient` int(11) NOT NULL,
  `IdAdmin` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL,
  `ModType` int(11) NOT NULL,
  `Report` text NOT NULL,
  PRIMARY KEY (`IdEntry`),
  KEY `idCliente` (`IdClient`),
  KEY `idAdmin` (`IdAdmin`),
  KEY `TipoModerazione` (`ModType`),
  CONSTRAINT `moderationlog_ibfk_1` FOREIGN KEY (`IdClient`) REFERENCES `clients` (`IdClient`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `moderationlog_ibfk_2` FOREIGN KEY (`IdAdmin`) REFERENCES `admins` (`IdAdmin`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `moderationlog_ibfk_3` FOREIGN KEY (`ModType`) REFERENCES `moderationtypes` (`IdModType`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella UsersDB.moderationlog: ~3 rows (circa)
/*!40000 ALTER TABLE `moderationlog` DISABLE KEYS */;
INSERT INTO `moderationlog` (`IdEntry`, `IdClient`, `IdAdmin`, `Timestamp`, `ModType`, `Report`) VALUES
	(1, 1, 1, '2017-04-05 22:00:00', 1, 'Sospeso per traffici sospetti'),
	(2, 1, 2, '2017-04-06 22:00:00', 3, 'Risolte le accuse di traffici sospetti'),
	(8, 2, 1, '2017-03-02 12:00:12', 2, 'Servizio instabile');
/*!40000 ALTER TABLE `moderationlog` ENABLE KEYS */;

-- Dump della struttura di tabella UsersDB.moderationtypes
CREATE TABLE IF NOT EXISTS `moderationtypes` (
  `IdModType` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(40) NOT NULL,
  `Description` text NOT NULL,
  PRIMARY KEY (`IdModType`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella UsersDB.moderationtypes: ~3 rows (circa)
/*!40000 ALTER TABLE `moderationtypes` DISABLE KEYS */;
INSERT INTO `moderationtypes` (`IdModType`, `Name`, `Description`) VALUES
	(1, 'SospUtente', 'Sospensione dell\'utente dall\'utilizzo dei microservizi di API Market'),
	(2, 'SospPagamenti', 'Sospensione dell\'utente dai pagamenti di API Market per l\'uso dei propri microservizi registrati'),
	(3, 'RevSospUtente', 'Revoca la sospensione dell\'utente dall\'utilizzo dei microservizi di API Market');
/*!40000 ALTER TABLE `moderationtypes` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
