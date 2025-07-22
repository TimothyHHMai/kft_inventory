-- miscellaneous

/*
CREATE TABLE miscellaneous (
  `miscID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
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
    IN in_name VARCHAR(50),
    IN in_quantity_box INT,
    IN in_individual_stock INT,
    IN in_box_stock INT
)
BEGIN
    INSERT INTO `miscellaneouss` (`name`, `quantity_box`, `individual_stock`, `in_box_stock`)
    VALUES (in_name, in_quantity_box, in_individual_stock, in_box_stock);
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
    IN in_name VARCHAR(50),
    IN in_quantity_box INT,
    IN in_individual_stock INT,
    IN in_box_stock INT
)
BEGIN
    UPDATE `miscellaneous`
    SET `name` = in_name,
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
    DELETE FROM `miscellaneouss`
    WHERE `miscellaneousID` = in_miscellaneousID;
END //

DELIMITER ;

-- add/subtract miscellaneouss
DELIMITER //
    
    CREATE PROCEDURE `addFromMiscellaneouss`(
    IN i_miscellaneousID INT,
    IN i_quantityToAddIndividual INT,
    IN i_quantityToAddBox INT
    
)
BEGIN
    DECLARE currentStockBox INT;
    DECLARE currentStockIndividual INT;

    SELECT `individual_stock`, `box_stock`
    INTO individualStock, boxStock
    FROM `miscellaneouss`
    WHERE `miscellaneousID` = i_miscellaneousID;

    IF individualStock IS NOT NULL AND individualStock >= p_quantityToAddIndividual AND
		boxStock IS NOT NULL AND boxStock >= p_quantityToAddBox THEN
        UPDATE `miscellaneouss`
        SET `individual_Stock` = individualStock + p_quantityToAddIndividual,
			`box_Stock` = boxStock + p_quantityToAddBox
        WHERE `miscellaneousID` = i_miscellaneousID;
        
		SELECT CONCAT('Successfully added ', p_quantityToAddBox, ' boxes and ', p_quantityToAddIndividual, ' individuals from stock for miscellaneousID ', i_miscellaneousID) AS message;

    ELSE
        SELECT 'Error: Product not found or insufficient stock' AS message;
    END IF;
END //

-- check if stock is low 