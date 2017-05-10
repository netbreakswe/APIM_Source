-- --------------------------------------------------------
-- Host:                         apimmicroservicesinstance.ccsrygwsp8kn.eu-west-2.rds.amazonaws.com
-- Versione server:              5.7.16-log - MySQL Community Server (GPL)
-- S.O. server:                  Linux
-- HeidiSQL Versione:            9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dump della struttura del database MicroservicesDB
CREATE DATABASE IF NOT EXISTS `MicroservicesDB` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `MicroservicesDB`;

-- Dump della struttura di tabella MicroservicesDB.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `IdCategory` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Image` varchar(50) NOT NULL,
  PRIMARY KEY (`IdCategory`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella MicroservicesDB.categories: ~5 rows (circa)
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` (`IdCategory`, `Name`, `Image`) VALUES
	(1, 'Giochi', 'https://categorie/giochi'),
	(2, 'Multimedia', 'https://categorie/multimedia'),
	(3, 'Notizie', 'https://categorie/notizie'),
	(4, 'Database', 'https://categorie/database'),
	(5, 'Geo', 'https://categorie/geo');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;

-- Dump della struttura di tabella MicroservicesDB.interfaces
CREATE TABLE IF NOT EXISTS `interfaces` (
  `IdInterface` int(11) NOT NULL AUTO_INCREMENT,
  `IdMS` int(11) NOT NULL,
  `Interf` text NOT NULL,
  `Loc` varchar(50) NOT NULL,
  `Protoc` varchar(50) NOT NULL,
  PRIMARY KEY (`IdInterface`),
  KEY `IdMS` (`IdMS`),
  CONSTRAINT `interfaces_ibfk_1` FOREIGN KEY (`IdMS`) REFERENCES `microservices` (`IdMS`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;


-- Dump della struttura di tabella MicroservicesDB.jnmscat
CREATE TABLE IF NOT EXISTS `jnmscat` (
  `IdMS` int(11) NOT NULL,
  `IdCategory` int(11) NOT NULL,
  PRIMARY KEY (`IdMS`,`IdCategory`),
  KEY `idMS` (`IdMS`),
  KEY `idCategoria` (`IdCategory`),
  CONSTRAINT `jnmscat_ibfk_1` FOREIGN KEY (`IdMS`) REFERENCES `microservices` (`IdMS`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `jnmscat_ibfk_2` FOREIGN KEY (`IdCategory`) REFERENCES `categories` (`IdCategory`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dump della struttura di tabella MicroservicesDB.microservices
CREATE TABLE IF NOT EXISTS `microservices` (
  `IdMS` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Description` text NOT NULL,
  `Version` int(11) NOT NULL,
  `LastUpdate` date NOT NULL,
  `IdDeveloper` int(11) NOT NULL,
  `Logo` varchar(50) NOT NULL,
  `DocPDF` text NOT NULL,
  `DocExternal` varchar(50) NOT NULL,
  `Profit` int(11) NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `SLAGuaranteed` double NOT NULL,
  `Policy` int(11) NOT NULL,
  PRIMARY KEY (`IdMS`),
  KEY `Policy` (`Policy`),
  CONSTRAINT `microservices_ibfk_1` FOREIGN KEY (`Policy`) REFERENCES `policies` (`IdPolicy`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- tabella che contiene interfaccia client aggregata dalla composizione di servizi
CREATE TABLE IF NOT EXISTS `clientinterf` (
  `IdCI` int(20) NOT NULL AUTO_INCREMENT,
  `IdMS` int(20) NOT NULL,
  `Interface` text NOT NULL,
  `Interface_Meta` longtext NOT NULL,
  PRIMARY KEY (`IdCI`),
  FOREIGN KEY (`IdMS`) REFERENCES `microservices` (`IdMS`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;


-- Dump della struttura di tabella MicroservicesDB.policies
CREATE TABLE IF NOT EXISTS `policies` (
  `IdPolicy` int(11) NOT NULL AUTO_INCREMENT,
  `MrktIncomePerc` int(11) NOT NULL,
  `Name` varchar(20) NOT NULL,
  PRIMARY KEY (`IdPolicy`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella MicroservicesDB.policies: ~3 rows (circa)
/*!40000 ALTER TABLE `policies` DISABLE KEYS */;
INSERT INTO `policies` (`IdPolicy`, `MrktIncomePerc`, `Name`) VALUES
	(1, 3, 'Per Chiamata'),
	(2, 4, 'Per Tempo'),
	(3, 5, 'Per Traffico');
/*!40000 ALTER TABLE `policies` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
