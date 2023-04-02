-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Address`
-- -----------------------------------------------------
DROP TABLE `mydb`.`Address`;
CREATE TABLE IF NOT EXISTS `mydb`.`Address` (
  `idAddress` INT NOT NULL,
  `street` VARCHAR(200) NULL,
  `additionalAddress` VARCHAR(200) NULL,
  `postalCode` VARCHAR(200) NULL,
  `city` VARCHAR(200) NULL,
  PRIMARY KEY (`idAddress`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
DROP TABLE `mydb`.`User`;
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `idUser` INT NOT NULL,
  `lastName` VARCHAR(200) NULL,
  `firstName` VARCHAR(200) NULL,
  `dateCreateAccount` DATE NULL,
  `phoneNumber` VARCHAR(200) NULL,
  `password` VARCHAR(200) NULL,
  `email` VARCHAR(200) NULL,
  `username` VARCHAR(250) NULL,
  PRIMARY KEY (`idUser`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Client`
-- -----------------------------------------------------
DROP TABLE `mydb`.`Client`;
CREATE TABLE IF NOT EXISTS `mydb`.`Client` (
  `User_idUser` INT NOT NULL,
  `Client_Address_idAddress` INT NOT NULL,
  INDEX `fk_Client_Address1_idx` (`Client_Address_idAddress` ASC) VISIBLE,
  INDEX `fk_Client_User1_idx` (`User_idUser` ASC) VISIBLE,
  PRIMARY KEY (`User_idUser`),
  CONSTRAINT `fk_Client_Address1`
    FOREIGN KEY (`Client_Address_idAddress`)
    REFERENCES `mydb`.`Address` (`idAddress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Client_User1`
    FOREIGN KEY (`User_idUser`)
    REFERENCES `mydb`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PointOfSale`
-- -----------------------------------------------------
DROP TABLE `mydb`.`PointOfSale`;
CREATE TABLE IF NOT EXISTS `mydb`.`PointOfSale` (
  `idPointOfSale` INT NOT NULL,
  `namePointOfSale` VARCHAR(200) NULL,
  `siret` VARCHAR(200) NULL,
  `AddressPointOfSale_idAddress` INT NOT NULL,
  `Employee_Manager_idUser` INT NOT NULL,
  PRIMARY KEY (`idPointOfSale`),
  INDEX `fk_PointOfSale_Address_idx` (`AddressPointOfSale_idAddress` ASC) VISIBLE,
  INDEX `fk_PointOfSale_Employee1_idx` (`Employee_Manager_idUser` ASC) VISIBLE,
  CONSTRAINT `fk_PointOfSale_Address`
    FOREIGN KEY (`AddressPointOfSale_idAddress`)
    REFERENCES `mydb`.`Address` (`idAddress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PointOfSale_Employee1`
    FOREIGN KEY (`Employee_Manager_idUser`)
    REFERENCES `mydb`.`Employee` (`User_idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employee`
-- -----------------------------------------------------
DROP TABLE `mydb`.`Employee`;
CREATE TABLE IF NOT EXISTS `mydb`.`Employee` (
  `User_idUser` INT NOT NULL,
  `role` ENUM('Manager', 'Pizzaiolo', 'Delivery Man') NULL,
  `PointOfSale_idPointOfSale` INT NULL,
  PRIMARY KEY (`User_idUser`),
  INDEX `fk_Employee_User1_idx` (`User_idUser` ASC) VISIBLE,
  INDEX `fk_Employee_PointOfSale1_idx` (`PointOfSale_idPointOfSale` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_User1`
    FOREIGN KEY (`User_idUser`)
    REFERENCES `mydb`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_PointOfSale1`
    FOREIGN KEY (`PointOfSale_idPointOfSale`)
    REFERENCES `mydb`.`PointOfSale` (`idPointOfSale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Order`
-- -----------------------------------------------------
DROP TABLE `mydb`.`Order`;
CREATE TABLE IF NOT EXISTS `mydb`.`Order` (
  `idOrder` INT NOT NULL AUTO_INCREMENT,
  `dateOrder` DATETIME NOT NULL DEFAULT '2022-01-01 00:00:00',
  `dateDelivery` DATETIME NOT NULL DEFAULT '2022-01-01 00:00:00',
  `statusOrder` ENUM('Saved', 'In preparation', 'In the course of delivery', 'Delivered') NOT NULL,
  `payMethod` ENUM('Credit Card', 'Cash') NULL,
  `amountHT` FLOAT NULL,
  `amountTTC` FLOAT NULL,
  `Client_User_idUser` INT NOT NULL,
  `Employee_Pizzaiolo_User_idUser` INT NOT NULL,
  `Employee_DeliveryMan_User_idUser1` INT NOT NULL,
  PRIMARY KEY (`idOrder`),
  INDEX `fk_Order_Client1_idx` (`Client_User_idUser` ASC) VISIBLE,
  INDEX `fk_Order_Employee1_idx` (`Employee_Pizzaiolo_User_idUser` ASC) VISIBLE,
  INDEX `fk_Order_Employee2_idx` (`Employee_DeliveryMan_User_idUser1` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Client1`
    FOREIGN KEY (`Client_User_idUser`)
    REFERENCES `mydb`.`Client` (`User_idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Employee1`
    FOREIGN KEY (`Employee_Pizzaiolo_User_idUser`)
    REFERENCES `mydb`.`Employee` (`User_idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Employee2`
    FOREIGN KEY (`Employee_DeliveryMan_User_idUser1`)
    REFERENCES `mydb`.`Employee` (`User_idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Product`
-- -----------------------------------------------------
DROP TABLE `mydb`.`Product`;
CREATE TABLE IF NOT EXISTS `mydb`.`Product` (
  `idProduct` INT NOT NULL,
  `nameProduct` VARCHAR(200) NULL,
  `size` VARCHAR(200) NULL,
  `composition` VARCHAR(200) NULL,
  `category` VARCHAR(200) NULL,
  `unitPriceHT` FLOAT NULL,
  `unitPriceTTC` FLOAT NULL,
  `recipe` VARCHAR(20000) NULL,
  PRIMARY KEY (`idProduct`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ingredient`
-- -----------------------------------------------------
DROP TABLE `mydb`.`Ingredient`;
CREATE TABLE IF NOT EXISTS `mydb`.`Ingredient` (
  `idIngredient` INT NOT NULL,
  `name` VARCHAR(200) NULL,
  `Product_idProduct` INT NOT NULL,
  PRIMARY KEY (`idIngredient`),
  INDEX `fk_Ingredient_Product1_idx` (`Product_idProduct` ASC) VISIBLE,
  CONSTRAINT `fk_Ingredient_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `mydb`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Stock`
-- -----------------------------------------------------
DROP TABLE `mydb`.`Stock`;
CREATE TABLE IF NOT EXISTS `mydb`.`Stock` (
  `idStock` INT NOT NULL,
  `datePurchase` DATE NULL,
  `dateExpiration` DATE NULL,
  `PointOfSale_idPointOfSale` INT NOT NULL,
  PRIMARY KEY (`idStock`),
  INDEX `fk_Stock_PointOfSale1_idx` (`PointOfSale_idPointOfSale` ASC) VISIBLE,
  CONSTRAINT `fk_Stock_PointOfSale1`
    FOREIGN KEY (`PointOfSale_idPointOfSale`)
    REFERENCES `mydb`.`PointOfSale` (`idPointOfSale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assoc_Order_Product`
-- -----------------------------------------------------
DROP TABLE `mydb`.`assoc_Order_Product`;
CREATE TABLE IF NOT EXISTS `mydb`.`assoc_Order_Product` (
  `Order_idOrder` INT NOT NULL,
  `Product_idProduct` INT NOT NULL,
  `quantity` INT NULL,
  INDEX `fk_assoc_Order_Product_Order1_idx` (`Order_idOrder` ASC) VISIBLE,
  INDEX `fk_assoc_Order_Product_Product1_idx` (`Product_idProduct` ASC) VISIBLE,
  PRIMARY KEY (`Order_idOrder`, `Product_idProduct`),
  CONSTRAINT `fk_assoc_Order_Product_Order1`
    FOREIGN KEY (`Order_idOrder`)
    REFERENCES `mydb`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assoc_Order_Product_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `mydb`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assoc_Ingredient_Stock`
-- -----------------------------------------------------
DROP TABLE `mydb`.`assoc_Ingredient_Stock`;
CREATE TABLE IF NOT EXISTS `mydb`.`assoc_Ingredient_Stock` (
  `Stock_idStock` INT NOT NULL,
  `Ingredient_idIngredient` INT NOT NULL,
  `quantityRemaining` INT NULL,
  `unit` VARCHAR(200) NULL,
  INDEX `fk_assoc_Ingredient_Stock_Stock1_idx` (`Stock_idStock` ASC) VISIBLE,
  INDEX `fk_assoc_Ingredient_Stock_Ingredient1_idx` (`Ingredient_idIngredient` ASC) VISIBLE,
  PRIMARY KEY (`Stock_idStock`, `Ingredient_idIngredient`),
  CONSTRAINT `fk_assoc_Ingredient_Stock_Stock1`
    FOREIGN KEY (`Stock_idStock`)
    REFERENCES `mydb`.`Stock` (`idStock`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assoc_Ingredient_Stock_Ingredient1`
    FOREIGN KEY (`Ingredient_idIngredient`)
    REFERENCES `mydb`.`Ingredient` (`idIngredient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `mydb`.`Address` (idAddress, street, additionalAddress, postalCode, city) VALUES
(1, 'Rue du Faubourg Saint-Honoré', NULL, '75008', 'Paris'),
(2, 'Avenue des Champs-Élysées', NULL, '75008', 'Paris'),
(3, 'Rue de la Paix', NULL, '75002', 'Paris');

INSERT INTO `mydb`.`User` (`idUser`, `lastName`, `firstName`, `dateCreateAccount`, `phoneNumber`, `password`, `email`, `username`) VALUES
(1, 'Smith', 'John', '2022-01-01', '1234567890', 'mypassword', 'john.smith@example.com', 'jsmith'),
(2, 'Doe', 'Jane', '2022-01-02', '2345678901', 'mypassword', 'jane.doe@example.com', 'jdoe'),
(3, 'Johnson', 'Michael', '2022-01-03', '3456789012', 'mypassword', 'michael.johnson@example.com', 'mjohnson'),
(4, 'Lee', 'Sarah', '2022-01-04', '4567890123', 'mypassword', 'sarah.lee@example.com', 'slee'),
(5, 'Brown', 'David', '2022-01-05', '5678901234', 'mypassword', 'david.brown@example.com', 'dbrown');

INSERT INTO `mydb`.`Client` (`User_idUser`, `Client_Address_idAddress`) VALUES
(1, 1);

INSERT INTO `mydb`.`Employee` (`User_idUser`, `role`, `PointOfSale_idPointOfSale`) VALUES
(2, 'Manager', NULL),
(3, 'Pizzaiolo', NULL),
(4, 'Delivery Man', NULL);

INSERT INTO `mydb`.`PointOfSale` (`idPointOfSale`, `namePointOfSale`, `siret`, `AddressPointOfSale_idAddress`, `Employee_Manager_idUser`) VALUES
(1, 'Pizza Place 1', '123456789', 2, 2);


update `mydb`.`Employee` set `PointOfSale_idPointOfSale` = 1 where `User_idUser` = 2;
update `mydb`.`Employee` set `PointOfSale_idPointOfSale` = 1 where `User_idUser` = 3;
update `mydb`.`Employee` set `PointOfSale_idPointOfSale` = 1 where `User_idUser` = 4; 

INSERT INTO `mydb`.`Order` (`dateOrder`, `dateDelivery`, `statusOrder`, `payMethod`, `amountHT`, `amountTTC`, `Client_User_idUser`, `Employee_Pizzaiolo_User_idUser`, `Employee_DeliveryMan_User_idUser1`) 
VALUES ('2022-03-31 15:30:00', '2022-03-31 18:45:00', 'In preparation', 'Credit Card', 25.0, 30.0, 1, 3, 4);

INSERT INTO mydb.Product (idProduct, nameProduct, size, composition, category, unitPriceHT, unitPriceTTC, recipe) VALUES
(1, 'Pizza Hawaïenne', 'Large', 'Jambon, Ananas, Fromage', 'Pizza salée', 10.00, 12.00, "1. Préchauffez le four à 220°C (thermostat 7-8) Étalez la pâte à pizza Étalez la sauce tomate sur la pâte Ajoutez le jambon   l'ananas et le fromage Enfournez pendant 12-15 minutes  Servez chaud."),
(2, 'Pizza Chocolat-banane', 'Medium', 'Chocolat, Banane, Sucre', 'Pizza sucrée', 8.00, 10.00, '1. Préchauffez le four à 200°C (thermostat 6-7) Étalez la pâte à pizza Étalez le chocolat sur la pâte Ajoutez les rondelles de banane et saupoudrez de sucre.\n5. Enfournez pendant 10-12 minutes Servez chaud.');

INSERT INTO `mydb`.`Ingredient` (idIngredient, name, Product_idProduct) VALUES
(1, 'Jambon', 1),
(2, 'Ananas', 1),
(3, 'Fromage', 1),
(4, 'Chocolat', 2),
(5, 'Banane', 2),
(6, 'Sucre', 2),
(7, 'Saucisse', 1),
(8, 'Champignons', 1),
(9, 'Poulet', 1),
(10, 'Poivrons', 1),
(11, 'Oeuf', 2),
(12, 'Noix de coco', 2),
(13, 'Miel', 2);

INSERT INTO mydb.assoc_Order_Product (Order_idOrder, Product_idProduct, quantity) VALUES (1, 1, 2),(1,2,3);

INSERT INTO `mydb`.`Stock` (`idStock`, `datePurchase`, `dateExpiration`, `PointOfSale_idPointOfSale`) 
VALUES (1, '2022-02-01', '2022-05-01', 1),
       (2, '2022-03-15', '2022-06-15', 1);
       
INSERT INTO `mydb`.`assoc_Ingredient_Stock` (`Stock_idStock`, `Ingredient_idIngredient`, `quantityRemaining`, `unit`)
VALUES (1, 1, 500, 'g'),
       (2, 2, 100, 'g');      




















