-- ingredients
/*
CREATE TABLE `ingredients` (
  `ingredientID` int NOT NULL AUTO_INCREMENT,
  `ingredientName` varchar(50) NOT NULL,
  `type` ENUM('Syrup', 'Powder', 'Topping', 'Tea') NOT NULL,
  `quantity_box` INT DEFAULT 0,
  `current_individual_stock` INT DEFAULT 0,
  `current_box_stock` INT DEFAULT 0,
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
    IN in_current_individual_stock INT,
    IN in_current_box_stock INT,
    IN in_expiration_date DATE
)
BEGIN
    INSERT INTO `ingredients` (`name`, `type`, `quantity_box`, `current_individual_stock`, `in_current_box_stock`, `expiration_date`)
    VALUES (in_name, in_type, in_quantity_box, in_current_individual_stock, in_current_box_stock, in_expiration_date);
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
    IN in_current_individual_stock INT,
    IN in_current_box_stock INT,
    IN in_expiration_date DATE
)
BEGIN
    UPDATE `ingredients`
    SET `name` = in_name,
        `type` = in_type,
        `quantity_box` = in_quantity_box,
        `current_individual_stock` = in_current_individual_stock,
        `current_box_stock` = in_current_box_stock,
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

CREATE PROCEDURE addFromIngredients(
    IN i_ingredientID INT,
    IN i_quantityToAddIndividual INT,
    IN i_quantityToAddBox INT
    
)
BEGIN
    DECLARE current_boxStock INT;
    DECLARE current_individualStock INT;
    DECLARE quantityBox INT;
    DECLARE msg VARCHAR(255);
	
    IF EXISTS (
		SELECT current_individual_stock, current_box_stock, quantity_box, ingredientName
		INTO current_individualStock, current_boxStock, quantityBox, ingredient_Name
		FROM ingredients
		WHERE ingredientID = i_ingredientID) THEN
        
		SET current_boxStock = quantityToAddBox;
		SET current_individualStock = current_individualStock + i_quantityToAddIndividual;
        
                
        IF current_individual_stock <= 0 AND current_boxStock > 0 THEN
			SET current_individual_stock = current_individualStock + quantityBox;
		ELSE
			SET msg = CONCAT(' ** WARNING** current box stock is empty'); 
		END IF;
            
		
		SET msg = concat('Successfully added ', i_quantityToAddBox, ' boxes and ', i_quantityToAddIndividual, ' individuals from stock for ingredientID ',
                i_ingredientID, i_ingredientName);
		SET msg = concat(' | remaining current_box_stock: ', current_boxStock, ' | remaining current_individual_stock: ', current_individualStock);
            
            
		UPDATE ingredients
			SET current_individual_stock = current_individualStock,
				current_box_stock = current_boxStock
			WHERE ingredientID = i_ingredientID;
			
			SELECT msg AS message;
        
	ELSE
			SELECT 'Error: Product not found or insufficient stock' AS message;
	END IF;
	
END //

DELIMITER ;

/*

DELIMITER //
CREATE PROCEDURE addFromIngredients(
    IN i_ingredientID INT,
    IN i_quantityToAddIndividual INT,
    IN i_quantityToAddBox INT
    
)
BEGIN
    DECLARE current_boxStock INT;
    DECLARE current_individualStock INT;

    SELECT current_individual_stock, current_box_stock
    INTO current_individualStock, current_boxStock
    FROM ingredients
    WHERE ingredientID = i_ingredientID;
	
    IF current_individualStock IS NOT NULL AND current_individualStock >= i_quantityToAddIndividual AND
		current_boxStock IS NOT NULL AND current_boxStock >= i_quantityToAddBox THEN
        UPDATE ingredients
        SET current_individual_stock = current_individualStock + i_quantityToAddIndividual,
			current_box_stock = current_boxStock + i_quantityToAddBox
        WHERE ingredientID = i_ingredientID;
        
		SELECT CONCAT('Successfully added ', i_quantityToAddBox, ' boxes and ', i_quantityToAddIndividual, ' individuals from stock for ingredientID ', i_ingredientID) AS message;

    ELSE
        SELECT 'Error: Product not found or insufficient stock' AS message;
    END IF;
END //

DELIMITER ;
*/

-- check if stock is low 