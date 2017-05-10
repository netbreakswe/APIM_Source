-- --------------------------------------------------------
-- Host:                         apimtransactionsinstance.ccsrygwsp8kn.eu-west-2.rds.amazonaws.com
-- Versione server:              5.7.16-log - MySQL Community Server (GPL)
-- S.O. server:                  Linux
-- HeidiSQL Versione:            9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dump della struttura del database TransactionsDB
CREATE DATABASE IF NOT EXISTS `TransactionsDB` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `TransactionsDB`;

-- Dump della struttura di tabella TransactionsDB.apikeys
CREATE TABLE IF NOT EXISTS `apikeys` (
  `IdAPIKey` int(11) NOT NULL AUTO_INCREMENT,
  `APIKey` varchar(100) NOT NULL,
  `IdMS` int(11) NOT NULL,
  `IdClient` int(11) NOT NULL,
  `Remaining` int(11) NOT NULL,
  PRIMARY KEY (`IdAPIKey`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella TransactionsDB.apikeys: ~3 rows (circa)
/*!40000 ALTER TABLE `apikeys` DISABLE KEYS */;
INSERT INTO `apikeys` (`IdAPIKey`, `IdMS`, `IdClient`, `Remaining`) VALUES
	(1, 4, 2, 300),
	(2, 1, 1, 55),
	(3, 7, 2, 101);
/*!40000 ALTER TABLE `apikeys` ENABLE KEYS */;

-- Dump della struttura di tabella TransactionsDB.purchases
CREATE TABLE IF NOT EXISTS `purchases` (
  `IdPurchase` int(11) NOT NULL AUTO_INCREMENT,
  `IdAPIKey` int(11) NOT NULL,
  `IdClient` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL,
  `Price` int(11) NOT NULL,
  `Amount` int(11) NOT NULL,
  PRIMARY KEY (`IdPurchase`),
  KEY `FK_purchases_apikeys` (`IdAPIKey`),
  CONSTRAINT `FK_purchases_apikeys` FOREIGN KEY (`IdAPIKey`) REFERENCES `apikeys` (`IdAPIKey`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella TransactionsDB.purchases: ~3 rows (circa)
/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
INSERT INTO `purchases` (`IdPurchase`, `IdAPIKey`, `IdClient`, `Timestamp`, `Price`, `Amount`) VALUES
	(1, 1, 2, '2017-03-11 12:12:12', 5, 300),
	(2, 2, 1, '2016-02-20 05:06:07', 2, 100),
	(3, 2, 1, '2017-07-17 17:07:01', 3, 50),
	(4, 3, 2, '2017-04-26 00:00:00', 7, 100);
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
