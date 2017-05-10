-- --------------------------------------------------------
-- Host:                         apimslainstance.ccsrygwsp8kn.eu-west-2.rds.amazonaws.com
-- Versione server:              5.7.16-log - MySQL Community Server (GPL)
-- S.O. server:                  Linux
-- HeidiSQL Versione:            9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dump della struttura del database SLADB
CREATE DATABASE IF NOT EXISTS `SLADB` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `SLADB`;

-- Dump della struttura di tabella SLADB.slasurveys
CREATE TABLE IF NOT EXISTS `slasurveys` (
  `IdSLASurvey` int(11) NOT NULL AUTO_INCREMENT,
  `IdAPIKey` int(11) NOT NULL,
  `IdMS` int(11) NOT NULL,
  `Timestamp` timestamp NOT NULL,
  `ResponseTime` double NOT NULL,
  `IsCompliant` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdSLASurvey`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella SLADB.slasurveys: ~4 rows (circa)
/*!40000 ALTER TABLE `slasurveys` DISABLE KEYS */;
INSERT INTO `slasurveys` (`IdSLASurvey`, `IdAPIKey`, `IdMS`, `Timestamp`, `ResponseTime`, `IsCompliant`) VALUES
	(1, 1, 1, '2017-04-06 20:52:20', 0.12, 1),
	(2, 2, 2, '2017-04-06 20:52:44', 4.46, 0),
	(3, 1, 1, '2017-04-06 20:53:23', 0.67, 1),
	(5, 3, 2, '2017-04-06 20:52:20', 0.167, 1);
/*!40000 ALTER TABLE `slasurveys` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
