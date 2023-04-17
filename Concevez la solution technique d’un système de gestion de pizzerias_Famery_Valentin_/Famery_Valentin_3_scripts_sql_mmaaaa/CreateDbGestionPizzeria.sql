-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `mydb`;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;



-- -----------------------------------------------------
-- Table `mydb`.`address`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`address` (
  `id` INT NOT NULL,
  `street` VARCHAR(200) NULL,
  `additional_address` VARCHAR(200) NULL,
  `postal_code` VARCHAR(200) NULL,
  `city` VARCHAR(200) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `id` INT NOT NULL,
  `last_name` VARCHAR(200) NULL,
  `first_name` VARCHAR(200) NULL,
  `date_create_account` DATE NULL,
  `phone_number` VARCHAR(200) NULL,
  `password` VARCHAR(200) NULL,
  `email` VARCHAR(200) NULL,
  `username` VARCHAR(250) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`client`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`client` (
  `id_user` INT NOT NULL,
  `id_address` INT NOT NULL,
  INDEX `fk_Client_Address1_idx` (`id_address` ASC) VISIBLE,
  INDEX `fk_Client_User1_idx` (`id_user` ASC) VISIBLE,
  PRIMARY KEY (`id_user`),
  CONSTRAINT `fk_Client_Address1`
    FOREIGN KEY (`id_address`)
    REFERENCES `mydb`.`address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Client_User1`
    FOREIGN KEY (`id_user`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`point_of_sale`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`point_of_sale` (
  `id` INT NOT NULL,
  `name` VARCHAR(200) NULL,
  `siret` VARCHAR(200) NULL,
  `id_address` INT NOT NULL,
  `manager_id_user` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_PointOfSale_Address_idx` (`id_address` ASC) VISIBLE,
  INDEX `fk_PointOfSale_Employee1_idx` (`manager_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_PointOfSale_Address`
    FOREIGN KEY (`id_address`)
    REFERENCES `mydb`.`address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PointOfSale_Employee1`
    FOREIGN KEY (`manager_id_user`)
    REFERENCES `mydb`.`employee` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`employee`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`employee` (
  `id_user` INT NOT NULL,
  `role` ENUM('Manager', 'Pizzaiolo', 'Delivery Man') NULL,
  `id_point_of_sale` INT NULL,
  PRIMARY KEY (`id_user`),
  INDEX `fk_Employee_User1_idx` (`id_user` ASC) VISIBLE,
  INDEX `fk_Employee_PointOfSale1_idx` (`id_point_of_sale` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_User1`
    FOREIGN KEY (`id_user`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_PointOfSale1`
    FOREIGN KEY (`id_point_of_sale`)
    REFERENCES `mydb`.`point_of_sale` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`order`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_create` DATETIME NOT NULL DEFAULT '2022-01-01 00:00:00',
  `date_delivery` DATETIME NOT NULL DEFAULT '2022-01-01 00:00:00',
  `status` ENUM('Created', 'In preparation', 'In the course of delivery', 'Delivered','Cancel') NOT NULL,
  `pay_method` ENUM('Credit Card', 'Cash') NULL,
  `amount_ht` FLOAT NULL,
  `amount_ttc` FLOAT NULL,
  `client_id_user` INT NOT NULL,
  `pizzaiolo_id_user` INT NOT NULL,
  `delivery_man_id_user` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Order_Client1_idx` (`client_id_user` ASC) VISIBLE,
  INDEX `fk_Order_Employee1_idx` (`pizzaiolo_id_user` ASC) VISIBLE,
  INDEX `fk_Order_Employee2_idx` (`delivery_man_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Client1`
    FOREIGN KEY (`client_id_user`)
    REFERENCES `mydb`.`client` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Employee1`
    FOREIGN KEY (`pizzaiolo_id_user`)
    REFERENCES `mydb`.`employee` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Employee2`
    FOREIGN KEY (`delivery_man_id_user`)
    REFERENCES `mydb`.`employee` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`product`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`product` (
  `id` INT NOT NULL,
  `name` VARCHAR(200) NULL,
  `size` VARCHAR(200) NULL,
  `composition` VARCHAR(200) NULL,
  `category` VARCHAR(200) NULL,
  `unit_price_ht` FLOAT NULL,
  `unit_price_ttc` FLOAT NULL,
  `recipe` VARCHAR(20000) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ingredient`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`ingredient` (
  `id` INT NOT NULL,
  `name` VARCHAR(200) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`stock`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`stock` (
  `id` INT NOT NULL,
  `date_purchase` DATE NULL,
  `date_expiration` DATE NULL,
  `id_point_of_sale` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Stock_PointOfSale1_idx` (`id_point_of_sale` ASC) VISIBLE,
  CONSTRAINT `fk_Stock_PointOfSale1`
    FOREIGN KEY (`id_point_of_sale`)
    REFERENCES `mydb`.`point_of_sale` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assoc_order_product`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`assoc_order_product` (
  `id_order` INT NOT NULL,
  `id_product` INT NOT NULL,
  `quantity` INT NULL,
  INDEX `fk_assoc_Order_Product_Order1_idx` (`id_order` ASC) VISIBLE,
  INDEX `fk_assoc_Order_Product_Product1_idx` (`id_product` ASC) VISIBLE,
  PRIMARY KEY (`id_order`, `id_product`),
  CONSTRAINT `fk_assoc_Order_Product_Order1`
    FOREIGN KEY (`id_order`)
    REFERENCES `mydb`.`order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assoc_Order_Product_Product1`
    FOREIGN KEY (`id_product`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`assoc_ingredient_stock`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`assoc_ingredient_stock` (
  `id_stock` INT NOT NULL,
  `id_ingredient` INT NOT NULL,
  `quantity` INT NULL,
  `unit` VARCHAR(200) NULL,
  INDEX `fk_assoc_Ingredient_Stock_Stock1_idx` (`id_stock` ASC) VISIBLE,
  INDEX `fk_assoc_Ingredient_Stock_Ingredient1_idx` (`id_ingredient` ASC) VISIBLE,
  PRIMARY KEY (`id_stock`, `id_ingredient`),
  CONSTRAINT `fk_assoc_Ingredient_Stock_Stock1`
    FOREIGN KEY (`id_stock`)
    REFERENCES `mydb`.`stock` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assoc_Ingredient_Stock_Ingredient1`
    FOREIGN KEY (`id_ingredient`)
    REFERENCES `mydb`.`ingredient` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`assoc_product_ingredient` (
  `id_product` INT NOT NULL,
  `id_ingredient` INT NOT NULL,
  `quantity_required` INT NULL,
  `unit` VARCHAR(43) NULL,
  INDEX `fk_assoc_product_ingredient_product_idx` (`id_product` ASC) VISIBLE,
  INDEX `fk_assoc_product_ingredient_ingredient_idx` (`id_ingredient` ASC) VISIBLE,
  PRIMARY KEY (`id_product`, `id_ingredient`),
  CONSTRAINT `fk_assoc_product_ingredient_product`
    FOREIGN KEY (`id_product`)
    REFERENCES `mydb`.`Product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assoc_product_ingredient_ingredient`
    FOREIGN KEY (`id_ingredient`)
    REFERENCES `mydb`.`Ingredient` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


INSERT INTO `mydb`.`address` (id, street, additional_address, postal_code, city) VALUES
(1, 'Rue du Faubourg Saint-Honoré', NULL, '75008', 'Paris'),
(2, 'Avenue des Champs-Élysées', NULL, '75008', 'Paris'),
(3, 'Rue de la Paix', NULL, '75002', 'Paris');

INSERT INTO `mydb`.`user` (`id`, `last_name`, `first_name`, `date_create_account`, `phone_number`, `password`, `email`, `username`) VALUES
(1, 'Smith', 'John', '2022-01-01', '1234567890', 'mypassword', 'john.smith@example.com', 'jsmith'),
(2, 'Doe', 'Jane', '2022-01-02', '2345678901', 'mypassword', 'jane.doe@example.com', 'jdoe'),
(3, 'Johnson', 'Michael', '2022-01-03', '3456789012', 'mypassword', 'michael.johnson@example.com', 'mjohnson'),
(4, 'Lee', 'Sarah', '2022-01-04', '4567890123', 'mypassword', 'sarah.lee@example.com', 'slee'),
(5, 'Brown', 'David', '2022-01-05', '5678901234', 'mypassword', 'david.brown@example.com', 'dbrown');

INSERT INTO `mydb`.`client` (id_user, id_address) VALUES
(1, 1);

INSERT INTO `mydb`.`employee` (`id_user`, `role`, `id_point_of_sale`) VALUES
(2, 'Manager', NULL),
(3, 'Pizzaiolo', NULL),
(4, 'Delivery Man', NULL);

INSERT INTO `mydb`.`point_of_sale` (`id`, `name`, `siret`, `id_address`, `manager_id_user`) VALUES
(1, 'Pizza Place 1', '123456789', 2, 2);


update `mydb`.`employee` set `id_point_of_sale` = 1 where `id_user` = 2;
update `mydb`.`employee` set `id_point_of_sale` = 1 where `id_user` = 3;
update `mydb`.`employee` set `id_point_of_sale` = 1 where `id_user` = 4; 

INSERT INTO `mydb`.`order` (`date_create`, `date_delivery`, `status`, `pay_method`, `amount_ht`, `amount_ttc`, `client_id_user`, `pizzaiolo_id_user` , `delivery_man_id_user`) 
VALUES ('2022-03-31 15:30:00', '2022-03-31 18:45:00', 'In preparation', 'Credit Card', 25.0, 30.0, 1, 3, 4);

INSERT INTO mydb.product (id, name, size, composition, category, unit_price_ht, unit_price_ttc, recipe) VALUES
(1, 'Pizza Hawaïenne', 'Large', 'Jambon, Ananas, Fromage', 'Pizza salée', 10.00, 12.00, "1. Préchauffez le four à 220°C (thermostat 7-8) Étalez la pâte à pizza Étalez la sauce tomate sur la pâte Ajoutez le jambon   l'ananas et le fromage Enfournez pendant 12-15 minutes  Servez chaud."),
(2, 'Pizza Chocolat-banane', 'Medium', 'Chocolat, Banane, Sucre', 'Pizza sucrée', 8.00, 10.00, '1. Préchauffez le four à 200°C (thermostat 6-7) Étalez la pâte à pizza Étalez le chocolat sur la pâte Ajoutez les rondelles de banane et saupoudrez de sucre.\n5. Enfournez pendant 10-12 minutes Servez chaud.');

INSERT INTO `mydb`.`ingredient` (id, name) VALUES
(1, 'Jambon'),
(2, 'Ananas'),
(3, 'Fromage'),
(4, 'Chocolat'),
(5, 'Banane'),
(6, 'Sucre'),
(7, 'Saucisse'),
(8, 'Champignons'),
(9, 'Poulet'),
(10, 'Poivrons'),
(11, 'Oeuf'),
(12, 'Noix de coco'),
(13, 'Miel');

INSERT INTO `mydb`.`assoc_product_ingredient` (id_product,id_ingredient,quantity_required,unit)VALUES 
(1,1,50,'g'),
(2,1,40,'g'),
(3,1,60,'g'),
(4,2,56,'g'),
(5,2,72,'g'),
(6,2,90,'g'),
(7,1,30,'g');

INSERT INTO mydb.assoc_order_product (id_order, id_product, quantity) VALUES (1, 1, 2),(1,2,3);

INSERT INTO `mydb`.`stock` (`id`, `date_purchase`, `date_expiration`, `id_point_of_sale`) 
VALUES (1, '2022-02-01', '2022-05-01', 1),
       (2, '2022-03-15', '2022-06-15', 1);
       
INSERT INTO `mydb`.`assoc_ingredient_stock` (`id_stock`, `id_ingredient`, `quantity`, `unit`)
VALUES (1, 1, 500, 'g'),
       (2, 2, 100, 'g');      




















