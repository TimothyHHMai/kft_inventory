-- miscellaneous

/*
CREATE TABLE miscellaneous (
  `miscellaneousID` INT NOT NULL AUTO_INCREMENT,
  `miscellaneous_name` VARCHAR(50) NOT NULL,
  `quantity_box` INT DEFAULT 0,
  `individual_stock` INT DEFAULT 0,
  `box_stock` INT DEFAULT 0,
  PRIMARY KEY (miscID)
);
*/

-- View Miscellaneous --
CREATE VIEW miscellaneous_list AS
SELECT	* 
FROM miscellaneous;

DELIMITER //

-- Insert Miscellaneous
CREATE PROCEDURE insert_miscellaneous(
    IN in_miscellaneous_name VARCHAR(50),
    IN in_quantity_box INT,
    IN in_individual_stock INT,
    IN in_box_stock INT
)
BEGIN
    INSERT INTO `miscellaneouss` (`miscellaneous_name`, `quantity_box`, `individual_stock`, `in_box_stock`)
    VALUES (in_miscellaneous_name, in_quantity_box, in_individual_stock, in_box_stock);
END //

DELIMITER ;

DELIMITER //

-- Read Miscellaneous
CREATE PROCEDURE get_all_miscellaneous()
BEGIN
    SELECT * 
    FROM miscellaneous;
END //

DELIMITER ;

DELIMITER //

-- Update Miscellaneous
CREATE PROCEDURE update_miscellaneous(
    IN in_miscellaneousID INT,
    IN in_miscellaneous_name VARCHAR(50),
    IN in_quantity_box INT,
    IN in_individual_stock INT,
    IN in_box_stock INT
)
BEGIN
    UPDATE `miscellaneous`
    SET `miscellaneous_name` = in_miscellaneous_name,
        `quantity_box` = in_quantity_box,
        `individual_stock` = in_individual_stock,
        `box_stock` = in_box_stock
    WHERE `miscellaneousID` = in_miscellaneousID;
END //

DELIMITER ;


DELIMITER //

-- Delete miscellaneous
CREATE PROCEDURE delete_miscellaneous(
    IN in_miscellaneousID INT
)
BEGIN
    DELETE FROM `miscellaneous`
    WHERE `miscellaneousID` = in_miscellaneousID;
END //

DELIMITER ;

-- add/subtract miscellaneous
-- **FRONT END add a caution confirmation if the result will be negative
DELIMITER //


CREATE PROCEDURE addFromMiscellaneous(
	IN auto_box INT, -- determines if current_individual_stock is reduced to zero, current_box_stock will automatically reduce
    IN i_miscellaneousID INT,
    IN i_quantityToAddIndividual INT,
    IN i_quantityToAddBox INT
)
BEGIN
    DECLARE temp_box_stock INT;
    DECLARE temp_individual_stock INT;
    DECLARE quantityBox INT;
    DECLARE miscellaneous_name VARCHAR(99);
    DECLARE msg VARCHAR(255);
    DECLARE row_found INT DEFAULT 1;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET row_found = 0;
    
	SELECT current_individual_stock, current_box_stock, quantity_box, miscellaneous_name
	INTO temp_individual_stock, temp_box_stock, quantityBox, miscellaneous_name
	FROM miscellaneous
	WHERE miscellaneousID = i_miscellaneousID;
        
	IF row_found = 1 THEN
        
		SET temp_box_stock = temp_box_stock + i_quantityToAddBox;
		SET temp_individual_stock = temp_individual_stock + i_quantityToAddIndividual;
        
        SET msg = '';
		
        break_loop: WHILE temp_individual_stock <= 0 DO
			
            IF temp_box_stock > 0 THEN
				SET temp_individual_stock = temp_individual_stock + quantityBox;
	
                IF auto_box = 1 THEN
					SET temp_box_stock = temp_box_stock - 1;
				END IF;
			ELSE
				SET msg = CONCAT(' ** WARNING** current box stock is empty | '); 
				LEAVE break_loop;
			END IF;
		END WHILE break_loop;
		
		SET msg = concat(msg, 'Successfully added ', i_quantityToAddBox, ' boxes and ', i_quantityToAddIndividual, ' individuals from stock for miscellaneousID ',
                i_miscellaneousID, ', ', miscellaneous_name);
		SET msg = concat(msg, ' | remaining current_box_stock: ', temp_box_stock, ' | remaining current_individual_stock: ', temp_individual_stock);
            
            
		UPDATE miscellaneous
			SET current_individual_stock = temp_individual_stock,
				current_box_stock = temp_box_stock
			WHERE miscellaneousID = i_miscellaneousID;
			
			SELECT msg AS message;
        
	ELSE
			SELECT 'Error: Item not found or insufficient stock' AS message;
	END IF;
	
END //

DELIMITER ;

-- Check if stock is under a threshold
DELIMITER //

-- 'i' = individual, 'b' = box
CREATE PROCEDURE check_supplies_miscellaneous (
	IN stock_type CHAR,
	IN threshold int
)
BEGIN 
	IF stock_type = 'i' THEN 
		SELECT miscellaneousmiscellaneous_name, current_individual_stock
        FROM miscellaneous
		WHERE current_individual_stock < threshold;
	ELSEIF stock_type = 'b' THEN
		SELECT miscellaneousmiscellaneous_name, current_box_stock
        FROM miscellaneous
		WHERE current_individual_stock < threshold;
	END IF;

END //

DELIMITER ;

DELIMITER //