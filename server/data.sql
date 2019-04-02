-- MySQL dump 10.16  Distrib 10.1.26-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: db
-- ------------------------------------------------------
-- Server version	10.1.26-MariaDB-0+deb9u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Blogs`
--

DROP TABLE IF EXISTS `Blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Blogs` (
  `id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `pictures` varchar(255) DEFAULT NULL,
  `content` text,
  `category` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Blogs`
--

LOCK TABLES `Blogs` WRITE;
/*!40000 ALTER TABLE `Blogs` DISABLE KEYS */;
INSERT INTO `Blogs` VALUES (6,'aaa','Technical-Interview---web-hands-on - Web.png','[{\"id\":2,\"name\":\"Technical-Interview---web-hands-on - Web.png\"}]','<p>aaaa</p>\n','aaaaa','saved','2019-03-29 00:00:00','2019-04-02 00:00:00'),(7,'bbb','logo.png','[{\"id\":1,\"name\":\"logo.png\"}]','<p>bbbb</p>\n','bbbbb','published','2019-03-29 00:00:00','2019-04-02 00:00:00'),(8,'ccc','quiz.PNG','[{\"id\":2,\"name\":\"quiz.PNG\"}]','<p>cccc</p>\n','ccccc','published','2019-03-29 00:00:00','2019-04-02 00:00:00'),(9,'ddd','adsMain.jpg','[{\"id\":1,\"name\":\"adsMain.jpg\"}]','<p><u><strong>dddd</strong></u></p>\n','ddddd','published','2019-04-01 00:00:00','2019-04-02 00:00:00');
/*!40000 ALTER TABLE `Blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Comments`
--

DROP TABLE IF EXISTS `Comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Comments` (
  `id` int(11) DEFAULT NULL,
  `blogId` varchar(255) DEFAULT NULL,
  `comment` text,
  `userId` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Comments`
--

LOCK TABLES `Comments` WRITE;
/*!40000 ALTER TABLE `Comments` DISABLE KEYS */;
INSERT INTO `Comments` VALUES (1,'20','comment testing','','2019-03-28 00:00:00','2019-03-28 00:00:00'),(2,'9','test comment','5','2019-04-01 00:00:00','2019-04-01 00:00:00'),(3,'9','aaaa','5','2019-04-01 00:00:00','2019-04-01 00:00:00'),(4,'9','add comment ja','8','2019-04-01 00:00:00','2019-04-01 00:00:00');
/*!40000 ALTER TABLE `Comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `id` int(11) DEFAULT NULL,
  `email` text,
  `password` text,
  `name` text,
  `lastname` text,
  `status` text,
  `type` text,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (2,'usertest@mail.com','$2a$08$t9kqpa/Oevkm86gDpD7NjePHNQfrW3bJqGlgWzCaCAeRhkIZX7xrW','userfirst_a','userlast_a','active','user','2019-03-21 00:00:00','2019-04-02 00:00:00'),(5,'jane@mail.com','$2a$08$t9kqpa/Oevkm86gDpD7NjePHNQfrW3bJqGlgWzCaCAeRhkIZX7xrW','jane','autotest','active','admin','2019-03-23 00:00:00','2019-03-26 00:00:00'),(8,'test@mail.com','$2a$08$t9kqpa/Oevkm86gDpD7NjePHNQfrW3bJqGlgWzCaCAeRhkIZX7xrW','test','test','active','user','2019-03-26 00:00:00','2019-04-02 00:00:00'),(9,'aaa@mail.com','$2a$08$t9kqpa/Oevkm86gDpD7NjePHNQfrW3bJqGlgWzCaCAeRhkIZX7xrW','userfirst_aaa','userlast_aaa','pause','user','2019-04-01 00:00:00','2019-04-02 00:00:00'),(10,'bbb@mail.com','$2a$08$t9kqpa/Oevkm86gDpD7NjePHNQfrW3bJqGlgWzCaCAeRhkIZX7xrW','bbbbb','bbbbb','active','user','2019-04-01 00:00:00','2019-04-02 00:00:00'),(11,'ccc@mail.com','$2a$08$t9kqpa/Oevkm86gDpD7NjePHNQfrW3bJqGlgWzCaCAeRhkIZX7xrW','ccccc','ccccc','active','user','2019-04-01 00:00:00','2019-04-02 00:00:00');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sqlite_sequence`
--

DROP TABLE IF EXISTS `sqlite_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sqlite_sequence` (
  `name` blob,
  `seq` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sqlite_sequence`
--

LOCK TABLES `sqlite_sequence` WRITE;
/*!40000 ALTER TABLE `sqlite_sequence` DISABLE KEYS */;
INSERT INTO `sqlite_sequence` VALUES ('Blogs','9'),('Comments','4'),('Users','11');
/*!40000 ALTER TABLE `sqlite_sequence` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-08 22:53:51
