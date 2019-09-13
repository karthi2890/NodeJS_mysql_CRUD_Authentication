-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema touchtosuccess
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema touchtosuccess
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `touchtosuccess` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `touchtosuccess` ;

-- -----------------------------------------------------
-- Table `touchtosuccess`.`store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `touchtosuccess`.`store` (
  `Id` INT(11) NOT NULL,
  `Phone` VARCHAR(255) NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  `Domain` VARCHAR(255) NOT NULL,
  `Status` VARCHAR(255) NOT NULL,
  `Street` VARCHAR(255) NOT NULL,
  `State` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `touchtosuccess`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `touchtosuccess`.`customer` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `StoreId` INT(11) NOT NULL,
  `Firstname` VARCHAR(255) NOT NULL,
  `Lastname` VARCHAR(255) NOT NULL,
  `Phone` VARCHAR(255) NULL DEFAULT NULL,
  `Email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `FK_Store` (`StoreId` ASC) VISIBLE,
  CONSTRAINT `FK_Store`
    FOREIGN KEY (`StoreId`)
    REFERENCES `touchtosuccess`.`store` (`Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4007
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `touchtosuccess`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `touchtosuccess`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `lastLoggedIn` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `touchtosuccess` ;

-- -----------------------------------------------------
-- procedure InsertCustomer
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertCustomer`(
in p_storeId int
,in p_firstName varchar(255)
,in p_lastName varchar(255)
,in p_phone varchar(255)
,in p_Email varchar(255)
)
BEGIN
INSERT INTO customer
	(StoreId,
	Firstname,
	Lastname,
	Phone,
	Email)
VALUES
	(p_storeId,
	p_firstName,
	p_lastName,
	p_phone,
	p_Email);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateStore
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStore`(
IN p_phone varchar(255),
IN p_Name varchar(255),
IN p_domain varchar(255),
IN p_status varchar(255),
IN p_street varchar(255),
IN p_state varchar(255),
IN p_id int
)
BEGIN
	UPDATE store 
    SET 
		Phone=ifnull(p_phone,phone),
        Name=ifnull(p_Name,Name),
        Domain=ifnull(p_domain,domain),
        Status=ifnull(p_status,status),
        Street=ifnull(p_street,street),
        State=ifnull(p_state,state)
    where Id=p_id;   

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure createUser
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser`(
in p_username varchar(255)
,in p_password varchar(255)
)
BEGIN
IF NOT EXISTS(SELECT 1 FROM user where username = p_username) 
THEN 
INSERT INTO user
	(username,
	password)
VALUES
	(p_username
    ,p_password);
select true as result;
else
	select false as result;
end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getStoreCustomers
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getStoreCustomers`()
BEGIN
SELECT 
	S.id,
    S.name,
    count(*) AS totalCount
FROM STORE S
INNER JOIN CUSTOMER C
ON S.ID=C.STOREID 
GROUP BY S.ID,S.NAME;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getStoreCustomersById
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getStoreCustomersById`(
IN p_id int
)
BEGIN
SELECT 
	C.FirstName,
    C.LastName,
    C.Email
FROM 
STORE S
INNER JOIN CUSTOMER C
ON S.ID=C.STOREID
WHERE S.ID=p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getStoreDetails
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getStoreDetails`()
BEGIN
select id, name
from store;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getStoreDetailsById
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getStoreDetailsById`(
in p_id int
)
BEGIN
SELECT Id,
    Phone,
    Name,
    Domain,
    Status,
    Street,
    State
FROM store where Id = p_id;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure searchStore
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchStore`(
in p_storename varchar(255)
)
BEGIN
SELECT Id,Name 
FROM Store where Name like concat('%',p_storename,'%')
LIMIT 5;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure validateUser
-- -----------------------------------------------------

DELIMITER $$
USE `touchtosuccess`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `validateUser`(
in p_username varchar(255),
in p_password varchar(255)
)
BEGIN

DECLARE p_lastLoggedIn datetime DEFAULT NULL;
DECLARE p_id int DEFAULT 0;


select @p_id := id as Id,@p_lastLoggedIn  := sysdate() as lastLoggedIn from user where username=p_username and password=p_password ;
IF @p_lastLoggedIn IS NOT NULL THEN 
	

	UPDATE USER set lastLoggedIn = p_lastLoggedIn where id =p_id;    
end if;
  
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
