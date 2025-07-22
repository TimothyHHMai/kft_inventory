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
    IN in_ingredientName VARCHAR(50),
    IN in_type ENUM('Syrup', 'Powder', 'Topping', 'Tea'),
    IN in_quantity_box INT,
    IN in_current_individual_stock INT,
    IN in_current_box_stock INT,
    IN in_expiration_date DATE
)
BEGIN
    INSERT INTO `ingredients` (`ingredientName`, `type`, `quantity_box`, `current_individual_stock`, `in_current_box_stock`, `expiration_date`)
    VALUES (in_ingredientName, in_type, in_quantity_box, in_current_individual_stock, in_current_box_stock, in_expiration_date);
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
    IN in_ningredientName VARCHAR(50),
    IN in_type ENUM('Syrup', 'Powder', 'Topping', 'Tea'),
    IN in_quantity_box INT,
    IN in_current_individual_stock INT,
    IN in_current_box_stock INT,
    IN in_expiration_date DATE
)
BEGIN
    UPDATE `ingredients`
    SET `name` = in_ingredientName,
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
    DECLARE temp_box_stock INT;
    DECLARE temp_individual_stock INT;
    DECLARE quantityBox INT;
    DECLARE ingredient_Name VARCHAR(99);
    DECLARE msg VARCHAR(255);
    DECLARE row_found INT DEFAULT 1;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET row_found = 0;
    
	SELECT current_individual_stock, current_box_stock, quantity_box, ingredientName
	INTO temp_individual_stock, temp_box_stock, quantityBox, ingredient_Name
	FROM ingredients
	WHERE ingredientID = i_ingredientID;
        
	IF row_found = 1 THEN
        
		SET temp_box_stock = temp_box_stock + i_quantityToAddBox;
		SET temp_individual_stock = temp_individual_stock + i_quantityToAddIndividual;
        
        SET msg = '';
                
        IF temp_individual_stock <= 0 THEN
            IF temp_box_stock > 0 THEN
				SET temp_individual_stock = temp_individual_stock + quantityBox;
			ELSE
				SET msg = CONCAT(' ** WARNING** current box stock is empty | '); 
			END IF;
		END IF;
            
		
		SET msg = concat(msg, 'Successfully added ', i_quantityToAddBox, ' boxes and ', i_quantityToAddIndividual, ' individuals from stock for ingredientID ',
                i_ingredientID, ', ', ingredient_Name);
		SET msg = concat(msg, ' | remaining current_box_stock: ', temp_box_stock, ' | remaining current_individual_stock: ', temp_individual_stock);
            
            
		UPDATE ingredients
			SET current_individual_stock = temp_individual_stock,
				current_box_stock = temp_box_stock
			WHERE ingredientID = i_ingredientID;
			
			SELECT msg AS message;
        
	ELSE
			SELECT 'Error: Product not found or insufficient stock' AS message;
	END IF;
	
END //

DELIMITER ;

-- check if stock is low 