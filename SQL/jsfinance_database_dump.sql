CREATE DATABASE  IF NOT EXISTS `jsfinance` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `jsfinance`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: jsfinance
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `id_at_institution` varchar(50) DEFAULT NULL,
  `institution_name` varchar(200) DEFAULT NULL,
  `account_nickname` varchar(50) DEFAULT NULL,
  `account_type` enum('loan','checkings','savings','401(k)','roth IRA','traditional IRA','529','taxable brokerage') DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `goal_id` int DEFAULT NULL,
  PRIMARY KEY (`account_id`),
  UNIQUE KEY `unique_bank_details` (`id_at_institution`,`institution_name`),
  UNIQUE KEY `unique_account_nickname` (`user_id`,`account_nickname`),
  KEY `fk_goal_id_accounts` (`goal_id`),
  CONSTRAINT `fk_goal_id_accounts` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`goal_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_id_accounts` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'78246166','Chase','my chase','checkings',1,3),(2,'14080047','Nelnet','NEU loan','loan',1,1),(3,'24694959','Ally','emergency fund','savings',1,2),(4,'44200220','Vanguard','Stryker 401k','401(k)',1,3),(5,'92304848','Santander','my loans','loan',1,4),(6,'65138110','NEU','NEU loan','loan',6,4),(7,'52294363','Bank of America','my savings','savings',6,NULL),(8,'73556977','Bank of America','my checkings','checkings',6,NULL),(9,'35148005','DFCU','savings','savings',5,NULL),(10,'15749776','DFCU','checkings','checkings',5,NULL),(11,'98783971','NEU','My 401k','401(k)',5,NULL),(12,'12124687','Empower','My Roth','roth IRA',5,NULL),(13,'45934710','Ally','my ally checkings','checkings',4,5),(14,'65331193','Ally','my ally savings','savings',4,5),(15,'73001785','NEU','NEU loan','loan',4,5),(16,'14812317','Robinhood','my brokerage','taxable brokerage',4,5),(17,'40657505','Chase','my checkings','checkings',7,6),(18,'56503256','Ally','my ally checkings','checkings',2,NULL),(19,'32550572','Ally','my ally savings','savings',2,NULL),(20,'72198045','Chase','my chase checkings','checkings',3,NULL),(21,'19313785','Chase','my chase savings','savings',3,NULL),(22,'13767696','Bank of America','checkings','checkings',8,7);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `families`
--

DROP TABLE IF EXISTS `families`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `families` (
  `family_id` int NOT NULL AUTO_INCREMENT,
  `family_name` varchar(100) NOT NULL,
  PRIMARY KEY (`family_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `families`
--

LOCK TABLES `families` WRITE;
/*!40000 ALTER TABLE `families` DISABLE KEYS */;
INSERT INTO `families` VALUES (1,'Witzig Padukone Household'),(2,'The Witzigs');
/*!40000 ALTER TABLE `families` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goals`
--

DROP TABLE IF EXISTS `goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goals` (
  `goal_id` int NOT NULL AUTO_INCREMENT,
  `goal_name` varchar(50) NOT NULL,
  `goal_amount` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`goal_id`),
  UNIQUE KEY `unique_goal_name_per_user` (`user_id`,`goal_name`),
  CONSTRAINT `fk_user_id_goals` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goals`
--

LOCK TABLES `goals` WRITE;
/*!40000 ALTER TABLE `goals` DISABLE KEYS */;
INSERT INTO `goals` VALUES (1,'Pay off my loans',0,1),(2,'Save $5000 emergency fund',5000,1),(3,'Net worth',200000,1),(4,'No more debt',0,6),(5,'Net worth',1000000,4),(6,'Dog fund',600,7),(7,'Cat fund',2000,8);
/*!40000 ALTER TABLE `goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `holdings`
--

DROP TABLE IF EXISTS `holdings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `holdings` (
  `holdings_id` int NOT NULL AUTO_INCREMENT,
  `number_shares` float DEFAULT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  PRIMARY KEY (`holdings_id`),
  KEY `fk_symbol_holdings` (`symbol`),
  KEY `fk_account_id_holdings` (`account_id`),
  CONSTRAINT `fk_account_id_holdings` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_symbol_holdings` FOREIGN KEY (`symbol`) REFERENCES `investments` (`symbol`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `holdings_shares_cant_be_negative` CHECK ((`number_shares` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `holdings`
--

LOCK TABLES `holdings` WRITE;
/*!40000 ALTER TABLE `holdings` DISABLE KEYS */;
INSERT INTO `holdings` VALUES (1,23605,'CASH',1),(2,80000,'DEBT',2),(3,3520.23,'CASH',3),(4,3000,'CASH',4),(5,26.2,'MS',4),(6,53.5,'NKE',4),(7,0.8,'LOW',4),(8,1.86,'MA',4),(9,60.5,'SBUX',4),(10,100,'F',4),(11,42042,'DEBT',5),(12,4031,'DEBT',6),(13,2472.05,'CASH',7),(14,2070.52,'CASH',8),(15,13596.3,'CASH',9),(16,2882.47,'CASH',10),(17,2813.32,'CASH',11),(18,55.52,'AMZN',11),(19,78.88,'AXP',11),(20,94.79,'BA',11),(21,14.79,'BAC',11),(22,92.38,'BIIB',11),(23,85.84,'COST',11),(24,56.66,'USD',11),(25,26.98,'V',11),(26,61.62,'PG',11),(27,90.6,'SO',11),(28,27.5,'TXN',11),(29,66.69,'UNH',11),(30,506.82,'CASH',12),(31,30,'AMZN',12),(32,3592.72,'CASH',13),(33,2244.4,'CASH',14),(34,40231,'DEBT',15),(35,32,'MCD',16),(36,100,'KO',16),(37,68.8,'F',16),(38,400,'CASH',17),(39,9563.75,'CASH',18),(40,13189.1,'CASH',19),(41,16980.9,'CASH',20),(42,12449.8,'CASH',21),(43,1804.64,'CASH',22);
/*!40000 ALTER TABLE `holdings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `investments`
--

DROP TABLE IF EXISTS `investments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investments` (
  `symbol` varchar(10) NOT NULL,
  `company_name` varchar(200) DEFAULT NULL,
  `daily_value` decimal(13,2) DEFAULT NULL,
  PRIMARY KEY (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investments`
--

LOCK TABLES `investments` WRITE;
/*!40000 ALTER TABLE `investments` DISABLE KEYS */;
INSERT INTO `investments` VALUES ('AAPL','Apple Inc',190.21),('ABBV','Abbvie Inc. Common Stock',144.11),('ABT','Abbott Laboratories',105.00),('ACN','Accenture Plc',334.63),('AIG','American International Group',65.80),('ALL','Allstate Corp',138.70),('AMGN','Amgen',271.87),('AMZN','Amazon.Com Inc',143.55),('AXP','American Express Company',172.10),('BA','Boeing Company',233.54),('BAC','Bank of America Corp',30.68),('BIIB','Biogen Inc Cmn',232.00),('BK','Bank of New York Mellon Corp',48.58),('BLK','Blackrock',755.62),('BMY','Bristol-Myers Squibb Company',49.80),('C','Citigroup Inc',47.01),('CASH','Cash',1.00),('CAT','Caterpillar Inc',253.78),('CL','Colgate-Palmolive Company',79.00),('CMCSA','Comcast Corp A',42.93),('COF','Capital One Financial Corp',114.44),('COP','Conocophillips',114.73),('COST','Costco Wholesale',598.53),('CSCO','Cisco Systems Inc',47.74),('CVS','CVS Corp',70.18),('CVX','Chevron Corp',144.76),('DD','E.I. Du Pont De Nemours and Company',71.21),('DEBT','Debt',-1.00),('DHR','Danaher Corp',221.32),('DIS','Walt Disney Company',91.61),('DOW','Dow Chemical Company',51.74),('DUK','Duke Energy Corp',92.86),('EMC','EMC Corp',24.29),('EMR','Emerson Electric Company',88.51),('EXC','Exelon Corp',38.79),('F','Ford Motor Company',10.64),('FDX','Fedex Corp',264.22),('FOX','21St Centry Fox B Cm',28.05),('FOXA','21St Centry Fox A Cm',30.21),('GD','General Dynamics Corp',252.23),('GE','General Electric Company',121.01),('GILD','Gilead Sciences Inc',78.37),('GM','General Motors Company',32.96),('GOOG','Alphabet Cl C Cap',130.37),('GOOGL','Alphabet Cl A Cmn',128.95),('GS','Goldman Sachs Group',346.60),('HAL','Halliburton Company',37.22),('HD','Home Depot',322.00),('HON','Honeywell International Inc',197.52),('IBM','International Business Machines',160.76),('INTC','Intel Corp',41.91),('JNJ','Johnson & Johnson',158.00),('JPM','JP Morgan Chase & Co',156.02),('KMI','Kinder Morgan',17.85),('KO','Coca-Cola Company',58.55),('LLY','Eli Lilly and Company',583.28),('LMT','Lockheed Martin Corp',450.29),('LOW','Lowe\'s Companies',205.71),('MA','Mastercard Inc',407.09),('MCD','McDonald\'s Corp',286.55),('MDLZ','Mondelez Intl Cmn A',71.06),('MDT','Medtronic Inc',79.55),('MET','Metlife Inc',64.13),('META','Facebook Inc',318.98),('MMM','3M Company',102.75),('MO','Altria Group',42.32),('MRK','Merck & Company',104.92),('MS','Morgan Stanley',80.68),('MSFT','Microsoft Corp',366.45),('NEE','Nextera Energy',58.68),('NKE','Nike Inc',114.66),('ORCL','Oracle Corp',114.57),('OXY','Occidental Petroleum Corp',57.98),('PEP','Pepsico Inc',169.15),('PFE','Pfizer Inc',29.21),('PG','Procter & Gamble Company',152.14),('PM','Philip Morris International Inc',92.52),('PYPL','Paypal Holdings',59.31),('QCOM','Qualcomm Inc',129.09),('SBUX','Starbucks Corp',97.38),('SLB','Schlumberger N.V.',51.66),('SO','Southern Company',71.38),('SPG','Simon Property Group',129.89),('T','AT&T Inc',16.98),('TGT','Target Corp',133.32),('TXN','Texas Instruments',156.46),('UNH','Unitedhealth Group Inc',549.10),('UNP','Union Pacific Corp',232.79),('UPS','United Parcel Service',155.00),('USB','U.S. Bancorp',39.26),('USD','Ultra Semiconductors Proshares',42.49),('V','Visa Inc',254.19),('VZ','Verizon Communications Inc',38.35),('WBA','Walgreens Bts Aln Cm',20.73),('WFC','Wells Fargo & Company',44.95);
/*!40000 ALTER TABLE `investments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `transaction_date` date DEFAULT NULL,
  `number_shares` float DEFAULT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `value_transacted_at` decimal(13,2) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `fk_symbol_transactions` (`symbol`),
  KEY `fk_account_id_transactions` (`account_id`),
  CONSTRAINT `fk_account_id_transactions` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_symbol_transactions` FOREIGN KEY (`symbol`) REFERENCES `investments` (`symbol`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(200) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `family_id` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_family_id_users` (`family_id`),
  CONSTRAINT `fk_family_id_users` FOREIGN KEY (`family_id`) REFERENCES `families` (`family_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'sarah@gmail.com','Sarah','Witzig',1),(2,'bill@gmail.com','William','Witzig',2),(3,'jo@gmail.com','Joanne','Witzig',2),(4,'joseph@gmail.com','Joseph','Mathew',NULL),(5,'k.durant@northeastern.edu','Kathleen','Durant',NULL),(6,'ronak@yahoo.com','Ronak','Padukone',1),(7,'matthew@gmail.com','Matthew','Witzig',NULL),(8,'katie@gmail.com','Katie','Markowitz',NULL),(9,'ang@gmail.com','Amanda','Ng',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'jsfinance'
--

--
-- Dumping routines for database 'jsfinance'
--
/*!50003 DROP FUNCTION IF EXISTS `create_family` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `create_family`(
	family_name_p VARCHAR(100)
    ) RETURNS int
    DETERMINISTIC
BEGIN
	-- Creates a family, and returns the family_id if successful. 

	-- Error Handling
    -- if family name is already taken
	IF EXISTS(SELECT * FROM families WHERE family_name = family_name_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That family name is already taken.';
	-- if family name longer than allowed
    ELSEIF LENGTH(family_name_p) > 100 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name exceeds 50 characters.';
    -- if family name is null
    ELSEIF family_name_p IS NULL OR family_name_p = '' THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name must be provided.';
	END IF;
    
    -- create the family
    INSERT INTO FAMILIES(family_name) VALUES (family_name_p);
    
    -- return the ID of the newly created family
    RETURN LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_account_id_from_user_id_and_account_nickname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_account_id_from_user_id_and_account_nickname`(user_id_p INT, account_nickname_p VARCHAR(100)) RETURNS int
    DETERMINISTIC
BEGIN
	-- given a user id and account nickname, this returns the account id
    DECLARE user_does_not_exist INT;
	DECLARE account_id_result INT;

    
	-- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
	-- Find the account id
    SELECT account_id INTO account_id_result FROM accounts where account_nickname = account_nickname_p AND user_id = user_id_p;
    
	-- Make sure account exists  
    IF account_id_result IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- Finally, return the account_id
    RETURN account_id_result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_user_family` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_user_family`(user_id_p INT) RETURNS int
    DETERMINISTIC
BEGIN
	-- given a user_id, return a family_id
	DECLARE result INT;
        
	SELECT family_id INTO result
	FROM users 
	WHERE user_id = user_id_p;
        
	-- user does not have family -> return -1
	IF result IS NULL THEN
		SELECT -1 INTO result;
	END IF;
        
	RETURN result;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_user_first_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_user_first_name`(user_id_p INT) RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	-- given a user_id, return a first name
	DECLARE result VARCHAR(100);
        
	SELECT first_name INTO result
	FROM users 
	WHERE user_id = user_id_p;
        
	-- user does not have first_name -> return -1
	IF result IS NULL THEN
		SELECT "" INTO result;
	END IF;
        
	RETURN result;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_user_id`(email_p VARCHAR(1000)) RETURNS int
    DETERMINISTIC
BEGIN
	-- given an email, return a user_id
	DECLARE result INT;
        
	SELECT user_id INTO result
	FROM users 
	WHERE email = email_p;
        
	-- user does not exist -> error message
	IF result IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot get user.";
	END IF;
        
	RETURN result;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `buy_investment_by_amount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_investment_by_amount`(
IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN dollars_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
	-- Executes a trade with the given dollar amount 
    DECLARE number_shares_p FLOAT;
    
    -- number shares = dollars/daily value
    SELECT dollars_p/daily_value INTO number_shares_p FROM investments WHERE symbol = symbol_p;
    
    -- execute the trade by calling buy_investment_shares_by_share
    CALL buy_investment_by_share(transaction_date_p, account_id_p, number_shares_p, symbol_p);
	
    -- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `buy_investment_by_amount_account_nickname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_investment_by_amount_account_nickname`(
IN transaction_date_p VARCHAR(50), IN account_nickname_p VARCHAR(100), IN user_id_p INT, IN dollars_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
	-- wrapper for buy_investment_shares_by_amount that lets input be account_nickname and user_id
	DECLARE account_id_p INT;

	-- Find the account id    
    SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;
    
    -- call the function
    CALL buy_investment_by_amount(transaction_date_p, account_id_p, dollars_p, symbol_p);
    
	-- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `buy_investment_by_share` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_investment_by_share`(
IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
    -- takes CASH from the specified account and buys stock
	DECLARE investment_daily_value FLOAT;
	DECLARE investment_total_cost FLOAT;
    DECLARE enough_cash_in_account INT;
	
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- See if symbol exists
    IF (SELECT COUNT(*) FROM investments WHERE symbol = symbol_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Investment symbol doesn't exist.";
    END IF;
    
    -- calculate the cost of the investment    
    SELECT daily_value INTO investment_daily_value FROM investments WHERE symbol = symbol_p;
    SELECT investment_daily_value * number_shares_p INTO investment_total_cost;
    
    -- See if enough cash is in account
    SELECT COUNT(*) > 0 INTO enough_cash_in_account 
    FROM holdings 
    WHERE account_id = account_id_p AND symbol = "CASH" AND number_shares > investment_total_cost;
	
    IF NOT enough_cash_in_account THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account doesn't contain sufficient cash funds to place trade.";
    END IF;
    
	-- Execute trade - first delete cash and then buy the stock
	CALL create_transaction(transaction_date_p, -1*investment_total_cost, "CASH", account_id_p);
	CALL create_transaction(transaction_date_p, number_shares_p, symbol_p, account_id_p);

	-- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `buy_investment_by_share_account_nickname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_investment_by_share_account_nickname`(
IN transaction_date_p VARCHAR(50), IN account_nickname_p VARCHAR(100), IN user_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
	DECLARE account_id_p INT;

	-- Find the account id    
    SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;
    
    -- call the function
    CALL buy_investment_by_share(transaction_date_p, account_id_p, number_shares_p, symbol_p);

	-- Return success code
	SELECT 200 AS result;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_account`(
    IN id_at_institution_p VARCHAR(50),
    IN institution_name_p VARCHAR(200),
    IN account_nickname_p VARCHAR(50),
    IN account_type_p VARCHAR(50),
    IN user_id_p INT,
    IN goal_name_p VARCHAR(50)
)
BEGIN
-- To create an account, institution details are needed (id at institution, institution name).
-- The account must be given a nickname UNIQUE to that user.
-- The account type must be specified, and must be equal to one of the account_type enums.
-- If a goal should be linked to the account, the goal_name must already be associated with
-- that user.
    DECLARE id_and_instution_combo_already_exists BOOLEAN;
	DECLARE goal_does_not_exist BOOLEAN;
    DECLARE goal_id_p INT;

	-- Error Handling -------------------------------------------------------------------------------------------
	-- Check if length of any values are too long
	IF LENGTH(id_at_institution_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'id_at_institution length cannot be more than 50 characters.';
    END IF;
	IF LENGTH(institution_name_p) > 200 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'institution_name length cannot be more than 50 characters.';
    END IF;
	IF LENGTH(account_nickname_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'account_nickname length cannot be more than 50 characters.';
    END IF;
    
	-- Check if account_type_p is one of the specified enums
    IF NOT account_type_p IN ('loan', 'checkings', 'savings', '401(k)', 'roth IRA', 'traditional IRA', '529', 'taxable brokerage') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid account_type.';
    END IF;

    -- Check if the account with the same id_at_institution and institution_name already exists
	SELECT COUNT(*) > 0 INTO id_and_instution_combo_already_exists 
    FROM accounts
	WHERE id_at_institution = id_at_institution_p AND institution_name = institution_name_p;
    
    IF id_and_instution_combo_already_exists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Combination of ID at institution and institution name already exists.";
    END IF;
    
    -- Check that a goal by that name exists with the current user
	SELECT COUNT(*) = 0 INTO goal_does_not_exist 
    FROM goals
	WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    -- if goal name is NULL, then goal_id is NULL and there's no error
    IF goal_name_p IS NULL THEN
		SELECT NULL into goal_id_p;
	-- If goal doesn't exist then raise error
	ELSEIF goal_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal by that name does not exist for this user.";
	-- If goal DOES exist by that name, then find the goal_id_p
	ELSE
		SELECT goal_id INTO goal_id_p
        FROM goals 
        WHERE goal_name = goal_name_p;
    END IF;

	INSERT INTO accounts (id_at_institution, institution_name, account_nickname, account_type, user_id, goal_id) 
    VALUES (id_at_institution_p, institution_name_p, account_nickname_p, account_type_p, user_id_p, goal_id_p);
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_goal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_goal`(
	IN goal_name_p VARCHAR(1000),
    IN goal_amount_p INT,
    IN user_id_p INT
)
BEGIN
	-- To create a goal, a goal name, amount, and user_id are needed.
	-- Errors occur if a goal by that name already exists for the given user, or
	-- if the given user does not exist.
	-- Goal amounts can be positive, 0, or negative
	DECLARE goal_name_already_in_use BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------
	-- Check if length of any values are too long
	IF LENGTH(goal_name_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'goal_name length cannot be more than 50 characters.';
    END IF;
    
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
	-- Check if the user_id / goal_name combo already exists
	SELECT COUNT(*) > 0 INTO goal_name_already_in_use FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    IF goal_name_already_in_use THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal name already exists for that user.";
    END IF;
    
	INSERT INTO goals (goal_name, goal_amount, user_id)
    VALUES (goal_name_p, goal_amount_p, user_id_p);

    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_investment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_investment`(
	IN symbol_p VARCHAR(10),
    IN company_name_p VARCHAR(200),
    IN daily_value_p DECIMAL(13,2)
    )
BEGIN
	DECLARE symbol_already_exists BOOLEAN;
    SELECT count(*) > 0 INTO symbol_already_exists FROM investments WHERE symbol = symbol_p;
    
	-- Error Handling
    -- if symbol or company name is null
    IF symbol_p IS NULL OR company_name_p IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'symbol and company name cannot be null.';

    -- if CASH is set to a value other than 1
    ELSEIF symbol_p = "CASH" and daily_value_p != 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CASH must be created with value 1.';

    -- if DEBT is set to a value other than -1
    ELSEIF symbol_p = "DEBT" and daily_value_p != -1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DEBT must be created with value -1.';
    
    -- if non-debt investment is negative
    ELSEIF symbol_p != "DEBT" and daily_value_p < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This investment cannot be negative.';
    
    END IF;

	-- if investment already exists, update the company name and daily value
    IF symbol_already_exists THEN
		UPDATE investments SET company_name = company_name_p WHERE symbol = symbol_p;
		UPDATE investments SET daily_value = daily_value_p WHERE symbol = symbol_p;
	
    -- otherwise, create the investment
    ELSE
		INSERT INTO investments(symbol, company_name, daily_value) 
		VALUES (symbol_p, company_name_p, daily_value_p);
	END IF;
    
	-- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_transaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_transaction`(
	IN transaction_date_p VARCHAR(50),
    IN number_shares_p FLOAT,
    IN symbol_p VARCHAR(10),
    IN account_id_p INT
    )
BEGIN
    DECLARE transaction_date_var DATE;
    DECLARE daily_value_var DECIMAL(13, 2);

	-- Error Handling
    -- if cash doesn't exist in database then insert it
    IF (SELECT COUNT(*) FROM investments WHERE symbol = "CASH") = 0 THEN
		INSERT INTO investments (symbol, company_name, daily_value) VALUES ("CASH", "Cash", 1);
	END IF;
    
    -- if debt doesn't exist in database then insert it
	IF (SELECT COUNT(*) FROM investments WHERE symbol = "DEBT") = 0 THEN
		INSERT INTO investments (symbol, company_name, daily_value) VALUES ("DEBT", "Debt", -1);
	END IF;
    
    -- if date isn't in correct format
    IF STR_TO_DATE(transaction_date_p, '%Y-%m-%d') IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect date format: please use YYYY-MM-DD.';

    -- if transaction date or number of shares are null
    ELSEIF transaction_date_p IS NULL OR number_shares_p IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date and number of shares must not be null.';

    -- if symbol doesn't exist
    ELSEIF NOT EXISTS (SELECT * FROM investments WHERE symbol = symbol_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Symbol is not found.';

    -- if account ID doesn't exist
    ELSEIF NOT EXISTS (SELECT * FROM accounts WHERE account_id = account_id_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account ID is not found.';
    END IF;

    -- since date has passed validation, convert the transaction date to a date format
    SELECT STR_TO_DATE(transaction_date_p, '%Y-%m-%d') INTO transaction_date_var;

    -- extract the daily value from the investments table, and assign it to a variable
    SELECT daily_value FROM investments where symbol = symbol_p INTO daily_value_var;

    -- create the transaction
    INSERT INTO transactions(transaction_date, number_shares, symbol, account_id, value_transacted_at)
    VALUES (transaction_date_var, number_shares_p, symbol_p, account_id_p, daily_value_var);
    
    -- If there is already a holdings tuple with the given symbol in that account, update
    IF EXISTS (SELECT * FROM holdings WHERE account_id = account_id_p AND symbol = symbol_p) THEN
		UPDATE holdings SET number_shares = number_shares + number_shares_p WHERE account_id = account_id_p AND symbol = symbol_p;
	-- if holdings tuple in that account DNE, create new tuple
    ELSE
		INSERT into holdings(number_shares, symbol, account_id) VALUES
        (number_shares_p, symbol_p, account_id_p);
    END IF;
    
	-- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`(
	IN email_p VARCHAR(200), 
    IN first_name_p VARCHAR(100),
    IN last_name_p VARCHAR(100),
    IN family_id_p INT)
BEGIN
	-- procedure for creating user
	-- Error Handling
    -- if email is already taken
	IF EXISTS(SELECT * FROM users WHERE email = email_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That email is already taken.';
	-- if first name or email parameters are null
    ELSEIF first_name_p IS NULL OR email_p IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First name and email must be provided.';
	-- if family id parameter doesn't exist
    ELSEIF family_id_p IS NOT NULL AND NOT EXISTS(SELECT * FROM families WHERE family_id = family_id_p) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family ID is not found.';
	END IF;
    
    -- create the user
    INSERT INTO USERS(email, first_name, last_name, family_id) VALUES (email_p, first_name_p, last_name_p, family_id_p);
    
	-- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_account`(IN account_nickname_p VARCHAR(1000), IN user_id_p INT)
BEGIN
-- An account can be deleted with its account nickname and the user_id.
-- If the user_id does not exist and the account nickname does not exist for that user then
-- an error occurs.
    DECLARE user_id_does_not_exist BOOLEAN;
	DECLARE account_nickname_does_not_exist BOOLEAN;

	-- Error Handling -------------------------------------------------------------------------------------------
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_id_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_id_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete account.";
    END IF;
    
    SELECT COUNT(*) != 1 INTO account_nickname_does_not_exist FROM accounts WHERE user_id = user_id_p AND account_nickname = account_nickname_p;
    IF account_nickname_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account nickname does not exist for that user, cannot delete account.";
	END IF;
    
    -- Execute Deletion
    DELETE FROM accounts WHERE account_nickname = account_nickname_p AND user_id = user_id_p;
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_family` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_family`(IN family_id_p INT)
BEGIN
-- To delete a family, a family_id is needed. If that family_id does not exist, then
-- an error is raised.
    DECLARE family_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if family exists
	SELECT COUNT(*) != 1 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    IF family_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot delete family.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM families WHERE family_id = family_id_p;
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_goal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_goal`(IN goal_name_p VARCHAR(1000), IN user_id_p INT)
BEGIN
	DECLARE goal_name_does_not_exist BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete goal.";
    END IF;
    
	-- Check if the goal name exists for that user
	SELECT COUNT(*) = 0 INTO goal_name_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    IF goal_name_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal doesn't exist for this user, cannot delete goals.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user`(IN user_id_p INT)
BEGIN
-- To delete a user, a user_id is needed. If that user_id does not exist, then
-- an error is raised.
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete user.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM users WHERE user_id = user_id_p;
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deposit_money` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deposit_money`(IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN amount_p FLOAT)
BEGIN
    -- deposits money into an account given an account id
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Make sure account exists  
    IF (SELECT COUNT(*) FROM accounts WHERE account_id = account_id_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- make the transaction
    CALL create_transaction(transaction_date_p, amount_p, "CASH", account_id_p);
    
	-- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deposit_money_by_account_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deposit_money_by_account_name`(
IN transaction_date_p VARCHAR(50), IN account_nickname_p VARCHAR(100), IN user_id_p INT, IN amount_p FLOAT)
BEGIN
    -- deposits money into an account given a user_id and an account nickname
    DECLARE account_id_p INT;
	
    -- Find the account_id_p (error handlin occurs in the function get_account_id_from_user_id_and_account_nickname)
	SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;

    -- make the transaction
    CALL deposit_money(transaction_date_p, account_id_p, amount_p);
    
	-- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sell_investment_by_amount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sell_investment_by_amount`(
IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN dollars_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
	-- Executes a trade with the given dollar amount 
    DECLARE number_shares_p FLOAT;
    
    -- number shares = dollars/daily value
    SELECT dollars_p/daily_value INTO number_shares_p FROM investments WHERE symbol = symbol_p;
    
    -- execute the trade by calling sell_investment_by_share
    CALL sell_investment_by_share(transaction_date_p, account_id_p, number_shares_p, symbol_p);

	-- Return success code
	SELECT 200 AS result;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sell_investment_by_amount_account_nickname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sell_investment_by_amount_account_nickname`(
IN transaction_date_p VARCHAR(50), IN account_nickname_p VARCHAR(100), IN user_id_p INT, IN dollars_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
	DECLARE account_id_p INT;

	-- Find the account id    
    SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;
    
    -- call the function
    CALL sell_investment_by_amount(transaction_date_p, account_id_p, dollars_p, symbol_p);
    
	-- Return success code
	SELECT 200 AS result;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sell_investment_by_share` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sell_investment_by_share`(
IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
	-- sells stock for CASH
	DECLARE investment_daily_value FLOAT;
	DECLARE investment_total_cost FLOAT;
    DECLARE shares_in_account FLOAT;
	
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- See if symbol exists
    IF (SELECT COUNT(*) FROM investments WHERE symbol = symbol_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Investment symbol doesn't exist.";
    END IF;
    
    -- calculate the cost of the investment    
    SELECT daily_value INTO investment_daily_value FROM investments WHERE symbol = symbol_p;
    SELECT investment_daily_value * number_shares_p INTO investment_total_cost;
    
    -- See if that many shares of investment are in the account
    SELECT number_shares INTO shares_in_account 
    FROM holdings 
    WHERE account_id = account_id_p AND symbol = symbol_p;
	
    IF shares_in_account < number_shares_p OR shares_in_account IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Not enough shares of investment are in the account.";
    END IF;
    
	-- Execute trade - first delete stock and then deposit the cash
	CALL create_transaction(transaction_date_p, -1*number_shares_p, symbol_p, account_id_p);
	CALL create_transaction(transaction_date_p, investment_total_cost, "CASH", account_id_p);
    
    -- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sell_investment_by_share_account_nickname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sell_investment_by_share_account_nickname`(
IN transaction_date_p VARCHAR(50), IN account_nickname_p VARCHAR(100), IN user_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
	DECLARE account_id_p INT;

	-- Find the account id    
    SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;
    
    -- call the function
    CALL sell_investment_by_share(transaction_date_p, account_id_p, number_shares_p, symbol_p);

	-- Return success code
	SELECT 200 AS result;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `take_loan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `take_loan`(IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN amount_p FLOAT)
BEGIN
    -- creates debt within an account
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Make sure account exists  
    IF (SELECT COUNT(*) FROM accounts WHERE account_id = account_id_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- make the transaction (always pass absolute value of amount)
    CALL create_transaction(transaction_date_p, abs(amount_p), "DEBT", account_id_p);
    
	-- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `take_loan_by_account_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `take_loan_by_account_name`(
IN transaction_date_p VARCHAR(50), IN account_nickname_p VARCHAR(100), IN user_id_p INT, IN amount_p FLOAT)
BEGIN
    -- deposits money into an account given a user_id and an account nickname
    DECLARE account_id_p INT;
	
    -- Find the account_id_p (error handlin occurs in the function get_account_id_from_user_id_and_account_nickname)
	SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;

    -- make the transaction
    CALL take_loan(transaction_date_p, account_id_p, amount_p);
    
	-- Return success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_accounts_goal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_accounts_goal`(IN user_id_p INT, IN account_nickname_p VARCHAR(1000), IN goal_name_p VARCHAR(1000))
BEGIN
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE account_does_not_exist BOOLEAN;
    DECLARE goal_does_not_exist BOOLEAN;
    DECLARE new_goal_id INT;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update account's goal.";
    END IF;
    
    -- Check if account with that name is associated with that user
	SELECT COUNT(*) = 0 INTO account_does_not_exist FROM accounts WHERE account_nickname = account_nickname_p AND user_id = user_id_p;
    IF account_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This account doesn't exist for this user, cannot update.";
    END IF;    
    
    -- Check if goal with that name is associated with that user
	SELECT COUNT(*) = 0 INTO goal_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    IF goal_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This goal doesn't exist for this user, cannot update.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
    -- find correct goal_id
    SELECT goal_id INTO new_goal_id FROM goals WHERE user_id = user_id_p and goal_name = goal_name_p;
    
	UPDATE accounts SET goal_id = new_goal_id WHERE user_id = user_id_p AND account_nickname = account_nickname_p;
    
	-- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_goal_amount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_goal_amount`(
	IN goal_name_p VARCHAR(1000),
    IN user_id_p INT, 
    IN new_goal_amount_p INT
)
BEGIN
-- To update a goal's amount, a goal name, amount, and a user_id are needed.
-- Errors occur if a goal by the old name doesn't exist for the given user, or
-- if the given user does not exist, or if a goal by that amount already
-- exists for the given user.
	DECLARE goal_name_does_not_exist BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE amount_is_same BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update goal amount.";
    END IF;
    
	-- Check if the OLD goal name exists for that user -> if it doesn't, raise error
	SELECT COUNT(*) = 0 INTO goal_name_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    IF goal_name_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal doesn't exist for this user, cannot update.";
    END IF;
    
    -- Check if the goal already has the same amount
    SELECT COUNT(*) != 0 INTO amount_is_same FROM goals WHERE user_id = user_id_p AND goal_name = goal_name_p AND goal_amount = new_goal_amount_p;
    IF amount_is_same THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A goal already exists with that name and amount.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
	UPDATE goals SET goal_amount = new_goal_amount_p WHERE user_id = user_id_p AND goal_name = goal_name_p;
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_goal_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_goal_name`(
	IN old_goal_name_p VARCHAR(1000),
    IN new_goal_name_p VARCHAR(1000),
    IN user_id_p INT
)
BEGIN
-- To update a goal's name, an old and new goal name and a user_id are needed.
-- Errors occur if a goal by the old name doesn't exist for the given user, or
-- if the given user does not exist, or if a goal by the new name already
-- exists for the given user.
	DECLARE old_goal_name_does_not_exist BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE new_goal_name_already_exists BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if new_goal_name_p is too long
	IF LENGTH(new_goal_name_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Goal name length cannot be more than 50 characters.';
    END IF;
    
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update goal name.";
    END IF;
    
	-- Check if the OLD goal name exists for that user -> if it doesn't, raise error
	SELECT COUNT(*) = 0 INTO old_goal_name_does_not_exist FROM goals WHERE goal_name = old_goal_name_p AND user_id = user_id_p;
    IF old_goal_name_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal doesn't exist for this user, cannot update.";
    END IF;
    
    -- Check if NEW goal name ALREADY exists for that user -> if it does, raise error
    SELECT COUNT(*) != 0 INTO new_goal_name_already_exists FROM goals WHERE user_id = user_id_p AND goal_name = new_goal_name_p;
    IF new_goal_name_already_exists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A goal already exists with the intended new name.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
	UPDATE goals SET goal_name = new_goal_name_p WHERE user_id = user_id_p AND goal_name = old_goal_name_p;
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_stock_daily_value` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_stock_daily_value`(IN symbol_p VARCHAR(10), IN new_daily_value_p DECIMAL(13,2)
)
BEGIN
	-- Error Handling
    -- if symbol is null
    IF symbol_p IS NULL THEN 
	    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Symbol cannot be null.';
    
    -- if symbol does not exist
	ELSEIF NOT EXISTS(SELECT * FROM investments WHERE symbol = symbol_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That symbol cannot be found';

    -- if erroneously attempting to update CASH or DEBT investments
    ELSEIF symbol_p = "CASH" OR symbol_p = "DEBT" THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This investment's value cannot be modified";

    -- if new_daily_value_p is negative
    ELSEIF new_daily_value_p < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New value cannot be negative.';

    END IF;
    
    -- update the stock's daily value
    UPDATE investments SET daily_value = new_daily_value_p WHERE symbol = symbol_p;

	-- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_family` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_family`(IN user_id_p INT, IN family_id_p INT
)
BEGIN
-- To update a user's family, the user_id and family_id must already exist.
-- If the family_id_p is the same as the existing family_id, an error occurs.
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE original_family_id_is_null BOOLEAN;
    DECLARE family_id_already_the_same BOOLEAN;
    DECLARE family_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update family.";
    END IF;
    
	-- Check if family doesn't exist for non-null family_id_p
	SELECT COUNT(*) = 0 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    IF family_does_not_exist and family_id_p IS NOT NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot update family.";
    END IF;
    
    -- Check if family was already equal to NULL when trying to make family null
	SELECT COUNT(*) = 1 INTO original_family_id_is_null FROM users WHERE user_id = user_id_p AND family_id IS NULL;
	IF original_family_id_is_null AND family_id_p IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User family was already NULL, no change needed.";
    END IF;
    
    -- Check if family was already equal to that value (does NOT work for NULL family)
	SELECT COUNT(*) = 1 INTO family_id_already_the_same FROM users WHERE user_id = user_id_p AND family_id = family_id_p;
	IF family_id_already_the_same THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User family was already the same value, no change needed.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
	UPDATE users set family_id = family_id_p where user_id = user_id_p;
    
    -- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_family_to_null` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_family_to_null`(IN user_id_p INT)
BEGIN
	-- To remove a user from a family, the user_id is needed. This procedure
	-- requires an existing user_id and for that user to already be associated
	-- with a family.
    CALL update_user_family(user_id_p, NULL);
    
	-- Success code
	SELECT 200 AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_accounts_details_for_family` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_accounts_details_for_family`(IN family_id_p INT)
BEGIN
	-- Given a family id, show account details table
    DECLARE family_does_not_exist BOOLEAN;
 
	-- Error Handling ----------------------------------------------------------------------------------------- 
    -- Check if family exists
    SELECT COUNT(*) != 1 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    IF family_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot retrieve account values.";
    END IF;
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
		accounts.account_nickname AS "Account Name",
		accounts.account_type AS "Account Type",
		CONCAT('$ ', FORMAT(SUM(number_shares * daily_value), 2), 0) AS "Account Value"
	FROM accounts 
    LEFT JOIN holdings ON accounts.account_id = holdings.account_id
    LEFT JOIN investments ON holdings.symbol = investments.symbol 
    JOIN users ON users.user_id = accounts.user_id
	WHERE users.family_id = family_id_p
	GROUP BY 
		accounts.account_nickname,
		accounts.account_type,
		accounts.account_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_accounts_details_for_family_by_type` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_accounts_details_for_family_by_type`(IN family_id_p INT)
BEGIN
	-- Given a family id, show account details grouped into Assets, Debt, and calculate Net Worth
    DECLARE family_does_not_exist BOOLEAN;

	-- Error Handling ----------------------------------------------------------------------------------------- 
    -- Check if family exists
    SELECT COUNT(*) != 1 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    
    IF family_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot retrieve account values.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
    CONCAT('$ ', FORMAT(COALESCE(SUM(
		CASE WHEN accounts.account_type != 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END
        ), 0), 2)) AS "Total Assets",
    CONCAT('$ ', FORMAT(COALESCE(SUM(
		CASE WHEN accounts.account_type = 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END
        ), 0), 2)) AS "Total Debts",
    CONCAT('$ ', FORMAT(COALESCE(SUM(
		CASE WHEN accounts.account_type = 'loan' THEN -1 * (number_shares * daily_value) 
             ELSE number_shares * daily_value 
        END
        ), 0), 2)) AS "Net Worth"
    FROM holdings 
    JOIN investments ON holdings.symbol = investments.symbol 
    JOIN accounts ON holdings.account_id = accounts.account_id
    JOIN users ON users.user_id = accounts.user_id
    WHERE users.family_id = family_id_p;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_accounts_details_for_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_accounts_details_for_user`(IN user_id_p INT)
BEGIN
	-- Given a user id, show account details table
    DECLARE user_does_not_exist BOOLEAN;

	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
    SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    
    IF user_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot retrieve account values.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
    SELECT 
		accounts.id_at_institution,
        accounts.institution_name,
        accounts.account_nickname AS "Account Name",
        accounts.account_type,
        CONCAT("$ ", FORMAT(COALESCE(ROUND(SUM(COALESCE(number_shares, 0) * COALESCE(daily_value, 0)), 2), 0), 2)) AS "Account Value"
    FROM accounts
    LEFT JOIN holdings ON accounts.account_id = holdings.account_id
    LEFT JOIN investments ON holdings.symbol = investments.symbol 
    WHERE accounts.user_id = user_id_p
    GROUP BY 
        accounts.account_nickname,
        accounts.account_type,
        accounts.account_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_accounts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_accounts`()
BEGIN
	-- View accounts table. Accounts with no goals are shown with goal_id = 0
	SELECT 
		account_id,
		id_at_institution,
		account_nickname,
		account_type,
		user_id,
		FORMAT(COALESCE(goal_id, 0), 0) AS "Goal ID"
    FROM accounts;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_families` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_families`()
BEGIN
	-- view family table
	SELECT * FROM families;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_goals` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_goals`()
BEGIN
	-- view goal table. Format money appropriately.
	SELECT 
		goal_id,
		goal_name,
		CONCAT('$ ', FORMAT(COALESCE(ROUND(goal_amount, 2), 0), 2)) AS "Goal Amount",
		user_id
    FROM goals;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_holdings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_holdings`()
BEGIN
	-- view holdings table
	SELECT * FROM holdings;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_investments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_investments`()
BEGIN
	-- view investments (stocks) table. Format money appropriately.
	SELECT 
		symbol, 
		company_name,
		CONCAT('$ ', FORMAT(COALESCE(ROUND(daily_value, 2), 0), 2)) AS "Daily Value"
	FROM investments;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_transactions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_transactions`()
BEGIN
	-- View transactions table. Format money appropriately.
	SELECT 
		transaction_id,
		transaction_date,
		number_shares,
		symbol,
		account_id,
		CONCAT('$ ', FORMAT(COALESCE(ROUND(value_transacted_at, 2), 0), 2)) AS "Value Transacted At"
    FROM transactions;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_users`()
BEGIN
	-- View users table (joined with family table to view family name)
	SELECT 
		user_id,
        email, 
        first_name,
        last_name,
        family_name
    FROM users LEFT JOIN families ON users.family_id = families.family_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_goals_for_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_goals_for_user`(IN user_id_p INT)
BEGIN
    DECLARE user_does_not_exist BOOLEAN;
 
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
    SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot retrieve account values.";
    END IF;
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
		COALESCE(GROUP_CONCAT(DISTINCT accounts.account_nickname SEPARATOR ", "), " - ") AS "Account Name(s)",
		goals.goal_name AS "Goal Name",
        CONCAT('$ ', FORMAT(COALESCE(SUM(number_shares * daily_value), 0), 2)) AS "Current Value",
        CONCAT('$ ', FORMAT(goals.goal_amount, 2)) AS "Goal Amount",
        CASE WHEN
        (ROUND(SUM(number_shares * daily_value), 2) >= ROUND(goals.goal_amount, 2)) = 1
        THEN "YES"
        ELSE "NO"
        END
        AS "Is obtained?"
	FROM goals 
    LEFT JOIN accounts ON goals.user_id = accounts.user_id AND goals.goal_id = accounts.goal_id
    LEFT JOIN holdings ON accounts.account_id = holdings.account_id
	LEFT JOIN investments ON holdings.symbol = investments.symbol 
    WHERE goals.user_id = user_id_p
	GROUP BY 
		goals.goal_name,
        goals.goal_amount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_my_holdings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_my_holdings`(IN user_id_p INT)
BEGIN
	-- given a user id, this shows the stock holdings of all accounts
    DECLARE user_does_not_exist INT;
    
	-- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
	SELECT 
		account_nickname, 
        account_type,
        symbol,
        number_shares, 
        CONCAT("$ ", format(daily_value, 2)) AS daily_value,
		CONCAT("$ ", format(number_shares*daily_value, 2)) AS total_value
    FROM holdings 
    NATURAL JOIN accounts 
    NATURAL JOIN investments 
    WHERE accounts.user_id = user_id_p AND number_shares > 0
	ORDER BY account_nickname, symbol;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_my_holdings_by_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_my_holdings_by_account`(IN user_id_p INT, IN account_nickname_p VARCHAR(100))
BEGIN
	-- given a user id, this shows the stock holdings of all accounts
    DECLARE user_does_not_exist INT;
    DECLARE account_id_p INT;
    
	-- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
    SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;
    
	SELECT 
		account_nickname, 
        account_type,
        symbol,
        number_shares, 
        CONCAT("$ ", format(daily_value, 2)) AS daily_value,
		CONCAT("$ ", format(number_shares*daily_value, 2)) AS total_value
    FROM holdings 
    NATURAL JOIN accounts 
    NATURAL JOIN investments 
    WHERE accounts.user_id = user_id_p AND number_shares > 0 AND accounts.account_id = account_id_p
	ORDER BY account_nickname, symbol;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_user_transactions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_user_transactions`(IN user_id_p INT)
BEGIN
	-- Given a user id, show 20 most recent transactions
    DECLARE user_does_not_exist BOOLEAN;

	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
    SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    
	IF user_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot retrieve transactions.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
	account_nickname, transaction_date, symbol, number_shares, concat("$ ", format(number_shares*value_transacted_at, 2)) AS total_amount
	FROM transactions 
	LEFT JOIN accounts ON transactions.account_id = accounts.account_id 
	WHERE user_id = user_id_p
	ORDER BY transaction_date DESC
	LIMIT 20;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-08 20:58:36
