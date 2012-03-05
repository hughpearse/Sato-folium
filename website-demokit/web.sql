SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`posts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`posts` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`posts` (
  `idposts` INT NOT NULL AUTO_INCREMENT ,
  `email` VARCHAR(45) NULL ,
  `url` VARCHAR(200) NULL DEFAULT NULL ,
  `comment` TEXT NULL DEFAULT NULL ,
  `whRatio` FLOAT NULL DEFAULT NULL ,
  `surfaceRatio` FLOAT NULL DEFAULT NULL ,
  `perimeterRatio` FLOAT NULL DEFAULT NULL ,
  `deviationR` FLOAT NULL DEFAULT NULL ,
  `deviationG` FLOAT NULL DEFAULT NULL ,
  `deviationB` FLOAT NULL DEFAULT NULL ,
  `meanR` FLOAT NULL DEFAULT NULL ,
  `meanG` FLOAT NULL DEFAULT NULL ,
  `meanB` FLOAT NULL DEFAULT NULL ,
  `maxR` FLOAT NULL DEFAULT NULL ,
  `maxG` FLOAT NULL DEFAULT NULL ,
  `maxB` FLOAT NULL DEFAULT NULL ,
  `gapRatio1` FLOAT NULL DEFAULT NULL ,
  `gapRatio2` FLOAT NULL DEFAULT NULL ,
  `gapRatio3` FLOAT NULL DEFAULT NULL ,
  `gapRatio4` FLOAT NULL DEFAULT NULL ,
  PRIMARY KEY (`idposts`) )
ENGINE = InnoDB;

CREATE UNIQUE INDEX `idposts_UNIQUE` ON `mydb`.`posts` (`idposts` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`genusAverage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`genusAverage` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`genusAverage` (
  `idgenus` INT NULL AUTO_INCREMENT ,
  `genus` VARCHAR(45) NULL ,
  `whRatio` FLOAT NULL DEFAULT NULL ,
  `surfaceRatio` FLOAT NULL DEFAULT NULL ,
  `perimeterRatio` FLOAT NULL DEFAULT NULL ,
  `deviationR` FLOAT NULL DEFAULT NULL ,
  `deviationG` FLOAT NULL DEFAULT NULL ,
  `deviationB` FLOAT NULL DEFAULT NULL ,
  `meanR` FLOAT NULL DEFAULT NULL ,
  `meanG` FLOAT NULL DEFAULT NULL ,
  `meanB` FLOAT NULL DEFAULT NULL ,
  `maxR` FLOAT NULL DEFAULT NULL ,
  `maxG` FLOAT NULL DEFAULT NULL ,
  `maxB` FLOAT NULL DEFAULT NULL ,
  `gapRatio1` FLOAT NULL DEFAULT NULL ,
  `gapRatio2` FLOAT NULL DEFAULT NULL ,
  `gapRatio3` FLOAT NULL DEFAULT NULL ,
  `gapRatio4` FLOAT NULL DEFAULT NULL ,
  PRIMARY KEY (`idgenus`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`speciesAverage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`speciesAverage` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`speciesAverage` (
  `idspecies` INT NULL AUTO_INCREMENT ,
  `species` VARCHAR(45) NULL DEFAULT NULL ,
  `genus` VARCHAR(45) NULL DEFAULT NULL ,
  `whRatio` FLOAT NULL DEFAULT NULL ,
  `surfaceRatio` FLOAT NULL DEFAULT NULL ,
  `perimeterRatio` FLOAT NULL DEFAULT NULL ,
  `deviationR` FLOAT NULL DEFAULT NULL ,
  `deviationG` FLOAT NULL DEFAULT NULL ,
  `deviationB` FLOAT NULL DEFAULT NULL ,
  `meanR` FLOAT NULL DEFAULT NULL ,
  `meanG` FLOAT NULL DEFAULT NULL ,
  `meanB` FLOAT NULL DEFAULT NULL ,
  `maxR` FLOAT NULL DEFAULT NULL ,
  `maxG` FLOAT NULL DEFAULT NULL ,
  `maxB` FLOAT NULL DEFAULT NULL ,
  `gapRatio1` FLOAT NULL DEFAULT NULL ,
  `gapRatio2` FLOAT NULL DEFAULT NULL ,
  `gapRatio3` FLOAT NULL DEFAULT NULL ,
  `gapRatio4` DECIMAL(5,5) NULL DEFAULT NULL ,
  PRIMARY KEY (`idspecies`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`varietyAverage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`varietyAverage` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`varietyAverage` (
  `idvariety` INT NULL AUTO_INCREMENT ,
  `variety` VARCHAR(60) NULL DEFAULT NULL ,
  `species` VARCHAR(45) NULL DEFAULT NULL ,
  `genus` VARCHAR(45) NULL DEFAULT NULL ,
  `whRatio` FLOAT NULL DEFAULT NULL ,
  `surfaceRatio` FLOAT NULL DEFAULT NULL ,
  `perimeterRatio` FLOAT NULL DEFAULT NULL ,
  `deviationR` FLOAT NULL DEFAULT NULL ,
  `deviationG` FLOAT NULL DEFAULT NULL ,
  `deviationB` FLOAT NULL DEFAULT NULL ,
  `meanR` FLOAT NULL DEFAULT NULL ,
  `meanG` FLOAT NULL DEFAULT NULL ,
  `meanB` FLOAT NULL DEFAULT NULL ,
  `maxR` FLOAT NULL DEFAULT NULL ,
  `maxG` FLOAT NULL DEFAULT NULL ,
  `maxB` FLOAT NULL DEFAULT NULL ,
  `gapRatio1` FLOAT NULL DEFAULT NULL ,
  `gapRatio2` FLOAT NULL DEFAULT NULL ,
  `gapRatio3` DECIMAL(5,5) NULL DEFAULT NULL ,
  `gapRatio4` FLOAT NULL DEFAULT NULL ,
  PRIMARY KEY (`idvariety`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`leaf`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`leaf` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`leaf` (
  `idleaf` INT NULL AUTO_INCREMENT ,
  `genus` VARCHAR(45) NULL ,
  `species` VARCHAR(45) NULL ,
  `variety` VARCHAR(60) NULL ,
  `whRatio` FLOAT NULL DEFAULT NULL ,
  `surfaceRatio` FLOAT NULL DEFAULT NULL ,
  `perimeterRatio` FLOAT NULL DEFAULT NULL ,
  `deviationR` FLOAT NULL DEFAULT NULL ,
  `deviationG` FLOAT NULL DEFAULT NULL ,
  `deviationB` FLOAT NULL DEFAULT NULL ,
  `meanR` FLOAT NULL DEFAULT NULL ,
  `meanG` FLOAT NULL DEFAULT NULL ,
  `meanB` FLOAT NULL DEFAULT NULL ,
  `maxR` FLOAT NULL DEFAULT NULL ,
  `maxG` FLOAT NULL DEFAULT NULL ,
  `maxB` FLOAT NULL DEFAULT NULL ,
  `gapRatio1` FLOAT NULL DEFAULT NULL ,
  `gapRatio2` FLOAT NULL DEFAULT NULL ,
  `gapRatio3` FLOAT NULL DEFAULT NULL ,
  `gapRatio4` FLOAT NULL DEFAULT NULL ,
  `url` VARCHAR(200) NULL ,
  PRIMARY KEY (`idleaf`) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

