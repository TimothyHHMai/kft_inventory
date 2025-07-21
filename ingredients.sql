-- ingredients
/*
CREATE TABLE `ingredients` (
  `ingredientID` int NOT NULL AUTO_INCREMENT,
  `ingredientName` varchar(50) NOT NULL,
  `type` ENUM('Syrup', 'Powder', 'Topping', 'Tea') NOT NULL,
  `quantity_box` INT DEFAULT 0,
  `individual_stock` INT DEFAULT 0,
  `box_stock` INT DEFAULT 0,
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
    IN in_individual_stock INT,
    IN in_box_stock INT,
    IN in_expiration_date DATE
)
BEGIN
    INSERT INTO `ingredients` (`name`, `type`, `quantity_box`, `individual_stock`, `in_box_stock`, `expiration_date`)
    VALUES (in_name, in_type, in_quantity_box, in_individual_stock, in_box_stock, in_expiration_date);
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
    IN in_individual_stock INT,
    IN in_box_stock INT,
    IN in_expiration_date DATE
)
BEGIN
    UPDATE `ingredients`
    SET `name` = in_name,
        `type` = in_type,
        `quantity_box` = in_quantity_box,
        `individual_stock` = in_individual_stock,
        `box_stock` = in_box_stock,
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

-- add/subtract ingredients
DELIMITER //
    
    CREATE PROCEDURE `addFromIngredients`(
    IN i_ingredientID INT,
    IN i_quantityToAddIndividual INT,
    IN i_quantityToAddBox INT
    
)
BEGIN
    DECLARE currentStockBox INT;
    DECLARE currentStockIndividual INT;

    SELECT `individual_stock`, `box_stock`
    INTO individualStock, boxStock
    FROM `ingredients`
    WHERE `ingredientID` = i_ingredientID;

    IF individualStock IS NOT NULL AND individualStock >= p_quantityToAddIndividual AND
		boxStock IS NOT NULL AND boxStock >= p_quantityToAddBox THEN
        UPDATE `ingredients`
        SET `individual_Stock` = individualStock + p_quantityToAddIndividual,
			`box_Stock` = boxStock + p_quantityToAddBox
        WHERE `ingredientID` = i_ingredientID;
        
		SELECT CONCAT('Successfully added ', p_quantityToAddBox, ' boxes and ', p_quantityToAddIndividual, ' individuals from stock for ingredientID ', i_ingredientID) AS message;

    ELSE
        SELECT 'Error: Product not found or insufficient stock' AS message;
    END IF;
END //

