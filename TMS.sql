-- MySQL dump 10.13  Distrib 5.7.23, for Linux (x86_64)
--
-- Host: localhost    Database: tenant_management
-- ------------------------------------------------------
-- Server version	5.7.23-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accepted_application`
--

DROP TABLE IF EXISTS `accepted_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accepted_application` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_appliaction` (`application_id`),
  CONSTRAINT `fk_appliaction` FOREIGN KEY (`application_id`) REFERENCES `unit_application` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accepted_application`
--

LOCK TABLES `accepted_application` WRITE;
/*!40000 ALTER TABLE `accepted_application` DISABLE KEYS */;
/*!40000 ALTER TABLE `accepted_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_requirements`
--

DROP TABLE IF EXISTS `application_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `application_requirements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unit` int(11) NOT NULL,
  `application_fee` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_apply_to_unit` (`unit`),
  CONSTRAINT `fk_apply_to_unit` FOREIGN KEY (`unit`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='application prerequisites of a unit ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_requirements`
--

LOCK TABLES `application_requirements` WRITE;
/*!40000 ALTER TABLE `application_requirements` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_requirements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice` (
  `tenant` int(11) NOT NULL,
  `invoice_number` int(50) NOT NULL,
  `invoice` blob NOT NULL,
  PRIMARY KEY (`invoice_number`),
  KEY `fk_billtothistenant` (`tenant`),
  CONSTRAINT `fk_billtothistenant` FOREIGN KEY (`tenant`) REFERENCES `occupant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leasing_info`
--

DROP TABLE IF EXISTS `leasing_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leasing_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `leasing_type` varchar(50) NOT NULL,
  `security_deposit` decimal(10,2) NOT NULL,
  `rent` decimal(10,2) NOT NULL,
  `utility_charge` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COMMENT='leasing information of a unit ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leasing_info`
--

LOCK TABLES `leasing_info` WRITE;
/*!40000 ALTER TABLE `leasing_info` DISABLE KEYS */;
INSERT INTO `leasing_info` VALUES (1,'monthly',10000.00,15000.00,5000.00),(2,'monthly',10000.00,15000.00,5000.00),(3,'monthly',10000.00,15000.00,5000.00),(4,'monthly',10000.00,15000.00,5000.00),(5,'monthly',10000.00,15000.00,5000.00);
/*!40000 ALTER TABLE `leasing_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_requests`
--

DROP TABLE IF EXISTS `maintenance_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maintenance_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `requester` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_requester` (`requester`),
  CONSTRAINT `fk_requester` FOREIGN KEY (`requester`) REFERENCES `occupant` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_requests`
--

LOCK TABLES `maintenance_requests` WRITE;
/*!40000 ALTER TABLE `maintenance_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `maintenance_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occupant`
--

DROP TABLE IF EXISTS `occupant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `occupant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `moved_in` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lease_period` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rented_unit` (`unit_id`),
  KEY `fk_occupant` (`user_id`),
  CONSTRAINT `fk_occupant` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rented_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupant`
--

LOCK TABLES `occupant` WRITE;
/*!40000 ALTER TABLE `occupant` DISABLE KEYS */;
INSERT INTO `occupant` VALUES (3,4,4,'2018-08-16 01:32:22',NULL);
/*!40000 ALTER TABLE `occupant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_log`
--

DROP TABLE IF EXISTS `payment_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_number` int(50) NOT NULL,
  `tenant` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_payer` (`tenant`),
  KEY `fk_invoice` (`invoice_number`),
  CONSTRAINT `fk_invoice` FOREIGN KEY (`invoice_number`) REFERENCES `invoice` (`invoice_number`) ON DELETE CASCADE,
  CONSTRAINT `fk_payer` FOREIGN KEY (`tenant`) REFERENCES `occupant` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_log`
--

LOCK TABLES `payment_log` WRITE;
/*!40000 ALTER TABLE `payment_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property`
--

DROP TABLE IF EXISTS `property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `property` (
  `ren_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `units_managed` int(50) NOT NULL,
  `registered_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `manager` int(11) NOT NULL,
  PRIMARY KEY (`ren_id`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_manager` (`manager`),
  CONSTRAINT `fk_manager` FOREIGN KEY (`manager`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COMMENT='Properties recorded by registered tenants. ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property`
--

LOCK TABLES `property` WRITE;
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
INSERT INTO `property` VALUES (1,'skylark','rongai',8,'2018-08-10 14:15:42',4),(2,'eddos','kitengela\r\n',2,'2018-08-10 14:16:36',4),(3,'Laiser Courst','Embakasi',5,'2018-08-13 05:26:28',2),(4,'Kikoy House','Westlands',8,'2018-08-13 05:27:36',2),(5,'Meso Flats','Riruta, Dagoretti',20,'2018-08-13 05:28:48',2),(6,'Zuri Apartments','Githurai 44',10,'2018-08-13 05:30:27',2),(7,'Mukami House','Ngara',20,'2018-08-13 05:31:03',6),(8,'Jamir Luxury Apartments','South B',20,'2018-08-13 05:32:00',6),(9,'Kenan Courts','Ngong Road',10,'2018-08-13 05:32:41',6),(10,'Sherehe Flats','Kayole',15,'2018-08-13 05:33:33',6),(11,'Mawingu Hostels','Figtree, Ngara',15,'2018-08-13 05:34:34',6),(12,'White House','State house Street',7,'2018-08-15 22:04:43',4),(14,'Black House','Dark Web Street',10,'2018-08-15 22:06:23',4);
/*!40000 ALTER TABLE `property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_application`
--

DROP TABLE IF EXISTS `unit_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_application` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `id_proof_document` varchar(50) NOT NULL,
  `id_proof_doc_no` varchar(50) NOT NULL,
  `submit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','accepted','rejected') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_applied_unit` (`unit_id`),
  KEY `fk_applicant` (`user_id`),
  CONSTRAINT `fk_applicant` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_applied_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COMMENT='Applications to rent listed vacant units ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_application`
--

LOCK TABLES `unit_application` WRITE;
/*!40000 ALTER TABLE `unit_application` DISABLE KEYS */;
INSERT INTO `unit_application` VALUES (1,3,4,'National ID','23232323','2018-08-15 22:21:43','accepted'),(2,3,4,'National ID','30229251','2018-08-15 22:23:35','rejected'),(3,3,4,'National ID','30229251','2018-08-15 22:23:47','rejected'),(4,3,5,'National ID','7676465543543','2018-08-16 00:51:48','accepted');
/*!40000 ALTER TABLE `unit_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units` (
  `unit_id` int(11) NOT NULL AUTO_INCREMENT,
  `property` int(11) NOT NULL,
  `unit_name` varchar(50) NOT NULL,
  `features` varchar(255) NOT NULL,
  `is_available` char(1) NOT NULL,
  `is_reserved` char(1) DEFAULT NULL,
  `lease_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`unit_id`),
  UNIQUE KEY `unit_name` (`unit_name`),
  KEY `fk_lease_details` (`lease_id`),
  KEY `fk_property_details` (`property`),
  CONSTRAINT `fk_lease_details` FOREIGN KEY (`lease_id`) REFERENCES `leasing_info` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_property_details` FOREIGN KEY (`property`) REFERENCES `property` (`ren_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1 COMMENT='units belonging to recorded properties ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (3,1,'A01','studio room \r\n','N','N',1),(4,1,'A-02','studio room','Y','N',1),(5,1,'A-03','studio room','Y','N',1),(6,1,'A-04','studio room','N','N',1),(7,1,'A-05','studio room','N','Y',1),(9,1,'A-06','studio room','Y','Y',1),(10,2,'E01','1 bedroom','Y','Y',2),(11,2,'E02','1 bedroom','N','Y',2),(12,2,'E03','2 bedroom Master Ensuite','N','N',3),(13,3,'house_1','2 bedroom Master Ensuite','N','N',4),(14,3,'house_2','3  bedroom Master Ensuite','N','N',5),(15,3,'house_3','3  bedroom Master Ensuite','Y','Y',5),(16,4,'Kikoy1','10*15(150 SF)','Y','Y',5),(17,4,'Kikoy2','10*15(150 SF)','Y','Y',5),(18,4,'Kikoy3','10*15(150 SF)','Y','Y',5),(20,4,'Kikoy4','12*10(120 SF)','N','N',5),(21,4,'Kikoy5','8*6(48 SF)','N','N',5),(22,4,'Kikoy6','10*10 (10 SF)','N','N',5),(23,11,'ROOM1','2-SHARING','N','N',5),(25,11,'ROOM2','2-SHARING','N','N',5),(27,11,'ROOM3','3-SHARING','N','N',5),(28,11,'ROOM4','3-SHARING','Y','N',5),(29,11,'ROOM5','3-SHARING','Y','N',5),(30,11,'ROOM6','3-SHARING','Y','N',5),(31,8,'A1','3BR','Y','N',5),(32,8,'B1','3BR','N','N',5),(33,8,'B2','3BR','N','N',5),(34,8,'B3','2BR','N','N',5),(37,8,'B4','2BR','Y','Y',5),(38,8,'B5','2BR','Y','Y',5),(39,1,'B04','bedsitter','N','N',NULL);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` enum('T','RM','ADMIN') NOT NULL,
  `first_name` varchar(15) NOT NULL,
  `last_name` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_number` int(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `signup_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COMMENT='system users ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'ADMIN','Grace','Murigi','gracemurigi95@gmail.com',729695435,'$5$rounds=535000$gT87VLewknc3br.E$fzdGRwTQY2LHJhkhP5T0VpzqYKLLhLiTbXpkwt2QKZ4','2018-07-17 06:24:06'),(2,'RM','Fridah ','Kanini ','kaninifridah436@gmail.com',725410486,'$5$rounds=535000$plOhm2lgdU5HDTYx$smAN2Z1g996s5hTCcM2X3QTYVXJOT5IWFYjMkW9WIa6','2018-07-17 06:26:07'),(3,'T','Marie ','Chemtai','mariechemu@gmail.com',700123456,'$5$rounds=535000$emrh0TpKv2TIDZwk$GyTKC63jKWn6Ep/85lkvIrjRyL6dsgRBk53kya08Xt/','2018-08-05 14:04:03'),(4,'RM','Griffin','Mfalme','mfalmegriffin@gmail.com',2147483647,'$5$rounds=535000$NyTi5EzJcioKQv.n$ZFLiHGqh0JbohrTFY8erUby1/68tZUMT5WSYUxGNZc.','2018-08-10 13:35:51'),(6,'RM','Joy ','Githu ','rosegrace68@gmail.com',700321654,'$5$rounds=535000$guGcz0GPHRPzfS9Q$nDOMbbWSZuy2QXSqk0N9kr33/q09EqYtGQ1AaBY1Mo7','2018-08-13 05:07:24'),(7,'T','Isaac ','Murray ','murray@live.ca',789254163,'$5$rounds=535000$qhvtUox28vKvodcU$dNbfNsquIDohw1mLsKFAzYY/ldfKZA.AsZqS5w0BeB1','2018-08-13 05:08:40');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-08-16  5:28:36
