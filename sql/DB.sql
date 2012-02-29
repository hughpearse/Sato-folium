SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';
 
DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `mydb` ;
 
-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`users` ;
 
CREATE  TABLE IF NOT EXISTS `mydb`.`users` (
  `email` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(45) NOT NULL ,
  `admin` TINYINT(1) NULL DEFAULT 0 ,
  PRIMARY KEY (`email`) )
ENGINE = InnoDB;
 
CREATE UNIQUE INDEX `email_UNIQUE` ON `mydb`.`users` (`email` ASC) ;
 
 
-- -----------------------------------------------------
-- Table `mydb`.`posts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`posts` ;
 
CREATE  TABLE IF NOT EXISTS `mydb`.`posts` (
  `idposts` INT NOT NULL AUTO_INCREMENT ,
  `email` VARCHAR(45) NOT NULL ,
  `filename` VARCHAR(60) NULL ,
  `comment` VARCHAR(250) NULL ,
  `whRatio` FLOAT NULL ,
  `surfaceRatio` FLOAT NULL ,
  `perimeterRatio` FLOAT NULL ,
  `deviationR` FLOAT NULL ,
  `deviationG` FLOAT NULL ,
  `deviationB` FLOAT NULL ,
  `meanR` FLOAT NULL ,
  `meanG` FLOAT NULL ,
  `meanB` FLOAT NULL ,
  `maxR` FLOAT NULL ,
  `maxG` FLOAT NULL ,
  `maxB` FLOAT NULL ,
  `gapRatio1` FLOAT NULL ,
  `gapRatio2` FLOAT NULL ,
  `gapRatio3` FLOAT NULL ,
  `gapRatio4` FLOAT NULL ,
  PRIMARY KEY (`idposts`) ,
  CONSTRAINT `email`
    FOREIGN KEY (`email` )
    REFERENCES `mydb`.`users` (`email` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
CREATE UNIQUE INDEX `idposts_UNIQUE` ON `mydb`.`posts` (`idposts` ASC) ;
 
 
-- -----------------------------------------------------
-- Table `mydb`.`genusAverage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`genusAverage` ;
 
CREATE  TABLE IF NOT EXISTS `mydb`.`genusAverage` (
  `genus` VARCHAR(45) NOT NULL ,
  `whRatio` FLOAT NULL ,
  `surfaceRatio` FLOAT NULL ,
  `perimeterRatio` FLOAT NULL ,
  `deviationR` FLOAT NULL ,
  `deviationG` FLOAT NULL ,
  `deviationB` FLOAT NULL ,
  `meanR` FLOAT NULL ,
  `meanG` FLOAT NULL ,
  `meanB` FLOAT NULL ,
  `maxR` FLOAT NULL ,
  `maxG` FLOAT NULL ,
  `maxB` FLOAT NULL ,
  `gapRatio1` FLOAT NULL ,
  `gapRatio2` FLOAT NULL ,
  `gapRatio3` FLOAT NULL ,
  `gapRatio4` FLOAT NULL ,
  PRIMARY KEY (`genus`) )
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `mydb`.`speciesAverage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`speciesAverage` ;
 
CREATE  TABLE IF NOT EXISTS `mydb`.`speciesAverage` (
  `species` VARCHAR(45) NULL ,
  `genus` VARCHAR(45) NULL ,
  `whRatio` FLOAT NULL ,
  `surfaceRatio` FLOAT NULL ,
  `perimeterRatio` FLOAT NULL ,
  `deviationR` FLOAT NULL ,
  `deviationG` FLOAT NULL ,
  `deviationB` FLOAT NULL ,
  `meanR` FLOAT NULL ,
  `meanG` FLOAT NULL ,
  `meanB` FLOAT NULL ,
  `maxR` FLOAT NULL ,
  `maxG` FLOAT NULL ,
  `maxB` FLOAT NULL ,
  `gapRatio1` FLOAT NULL ,
  `gapRatio2` FLOAT NULL ,
  `gapRatio3` FLOAT NULL ,
  `gapRatio4` FLOAT NULL ,
  PRIMARY KEY (`species`, `genus`) )
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `mydb`.`varietyAverage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`varietyAverage` ;
 
CREATE  TABLE IF NOT EXISTS `mydb`.`varietyAverage` (
  `variety` VARCHAR(60) NULL ,
  `species` VARCHAR(45) NULL ,
  `genus` VARCHAR(45) NULL ,
  `whRatio` FLOAT NULL ,
  `surfaceRatio` FLOAT NULL ,
  `perimeterRatio` FLOAT NULL ,
  `deviationR` FLOAT NULL ,
  `deviationG` FLOAT NULL ,
  `deviationB` FLOAT NULL ,
  `meanR` FLOAT NULL ,
  `meanG` FLOAT NULL ,
  `meanB` FLOAT NULL ,
  `maxR` FLOAT NULL ,
  `maxG` FLOAT NULL ,
  `maxB` FLOAT NULL ,
  `gapRatio1` FLOAT NULL ,
  `gapRatio2` FLOAT NULL ,
  `gapRatio3` FLOAT NULL ,
  `gapRatio4` FLOAT NULL ,
  PRIMARY KEY (`variety`, `species`, `genus`) )
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `mydb`.`leaf`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`leaf` ;
 
CREATE  TABLE IF NOT EXISTS `mydb`.`leaf` (
  `genus` VARCHAR(45) NOT NULL ,
  `species` VARCHAR(45) NOT NULL ,
  `variety` VARCHAR(60) NOT NULL ,
  `idleaf` INT NULL ,
  `whRatio` FLOAT NULL ,
  `surfaceRatio` FLOAT NULL ,
  `perimeterRatio` FLOAT NULL ,
  `deviationR` FLOAT NULL ,
  `deviationG` FLOAT NULL ,
  `deviationB` FLOAT NULL ,
  `meanR` FLOAT NULL ,
  `meanG` FLOAT NULL ,
  `meanB` FLOAT NULL ,
  `maxR` FLOAT NULL ,
  `maxG` FLOAT NULL ,
  `maxB` FLOAT NULL ,
  `gapRatio1` FLOAT NULL ,
  `gapRatio2` FLOAT NULL ,
  `gapRatio3` FLOAT NULL ,
  `gapRatio4` FLOAT NULL ,
  PRIMARY KEY (`genus`, `species`, `variety`, `idleaf`) )
ENGINE = InnoDB;
 
 
 
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

