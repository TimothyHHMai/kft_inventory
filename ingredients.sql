-- ingredients
/*
CREATE TABLE `ingredients` (
  `ingredientID` int NOT NULL AUTO_INCREMENT,
  `ingredientName` varchar(50) NOT NULL,
  `type` ENUM('Syrup', 'Powder', 'Topping', 'Tea') NOT NULL,
  `quantity_box` INT DEFAULT 0,
  `quantity_individual` INT DEFAULT 0,
  `expiration_date` DATE NOT NULL,
  PRIMARY KEY (`ingredientID`)
);
*/
-- View Ingredients --
CREATE VIEW ingredients_list AS
SELECT	* 
FROM ingredients;

DELIMITER //

-- Insert Ingredients
CREATE PROCEDURE insert_ingredient(
    IN in_name VARCHAR(50),
    IN in_type ENUM('Syrup', 'Powder', 'Topping', 'Tea'),
    IN in_quantity_box INT,
    IN in_quantity_individual INT,
    IN in_expiration_date DATE
)
BEGIN
    INSERT INTO `ingredients` (`name`, `type`, `quantity_box`, `quantity_individual`, `expiration_date`)
    VALUES (in_name, in_type, in_quantity_box, in_quantity_individual, in_expiration_date);
END //

DELIMITER ;

DELIMITER //

-- Read Ingredients
CREATE PROCEDURE get_all_ingredients()
BEGIN
    SELECT * 
    FROM ingredients;
END //

DELIMITER ;

DELIMITER //

-- Update Ingredients
CREATE PROCEDURE update_ingredient(
    IN in_ingredientID INT,
    IN in_name VARCHAR(50),
    IN in_type ENUM('Syrup', 'Powder', 'Topping', 'Tea'),
    IN in_quantity_box INT,
    IN in_quantity_individual INT,
    IN in_expiration_date DATE
)
BEGIN
    UPDATE `ingredients`
    SET `name` = in_name,
        `type` = in_type,
        `quantity_box` = in_quantity_box,
        `quantity_individual` = in_quantity_individual,
        `expiration_date` = in_expiration_date
    WHERE `ingredientID` = in_ingredientID;
END //

DELIMITER ;


DELIMITER //

-- Delete Ingredients
CREATE PROCEDURE delete_ingredient(
    IN in_ingredientID INT
)
BEGIN
    DELETE FROM `ingredients`
    WHERE `ingredientID` = in_ingredientID;
END //

DELIMITER ;


