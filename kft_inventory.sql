/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`kftinventory` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `kftinventory`;

/*Data for the table `ingredients` */

DROP TABLE IF EXISTS `ingredients`;

CREATE TABLE `ingredients` (
  `ingredientID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `type` ENUM('Syrup', 'Powder', 'Topping', 'Tea') NOT NULL,
  `quantity_box` INT DEFAULT 0,
  `current_individual_stock` INT DEFAULT 0,
  `current_box_stock` INT DEFAULT 0,
  `expiration_date` DATE NOT NULL,
  PRIMARY KEY (`ingredientID`)
);

/*Data for the table `miscellaneous` */

DROP TABLE IF EXISTS `miscellaneous`;

CREATE TABLE miscellaneous (
  `miscID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `quantity_box` INT DEFAULT NULL,
  `current_individual_stock` INT DEFAULT NULL,
  `current_box_stock` INT DEFAULT 0,
  PRIMARY KEY (miscID)
);

/*Data for the table `ingredients` */
INSERT INTO `ingredients`(`name`, `type`, `quantity_box`, `current_individual_stock`, `current_box_stock`, `expiration_date`) VALUES 
('Mango Popping', 'Topping', 4, 3, 3, '2026-06-30'),
('Crystal Boba', 'Topping', 20, 15, 4, '2026-04-30'),
('Boba', 'Topping', 8, 8, 12, '2026-05-28'),
('Strawberry Syrup', 'Syrup', 4, 4, 5, '2026-05-30');


/*Data for the table `miscellaneous` */
INSERT INTO `miscellaneous`(`name`,`quantity_box`, `current_individual_stock`, `current_box_stock`) VALUES 
('Large Straws', NULL, NULL, 6),
('Small Straws', NULL, NULL, 3),
('Large Cups', NULL, NULL, 3),
('Medium Cups', NULL, NULL, 5);

