-- MySQL Script generated by MySQL Workbench
-- Sun Sep 24 12:40:41 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema casoestudio2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema casoestudio2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `casoestudio2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `casoestudio2` ;

-- -----------------------------------------------------
-- Table `casoestudio2`.`directores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`directores` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pagoAnual` INT NOT NULL,
  `bonificaconMensual` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`oficinas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`oficinas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(30) NOT NULL,
  `ciudad` VARCHAR(15) NOT NULL,
  `fax` VARCHAR(10) NULL DEFAULT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`platilla`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`platilla` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dni` VARCHAR(10) NOT NULL,
  `nombre` VARCHAR(15) NOT NULL,
  `direccion` VARCHAR(30) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `fechaNacimiento` DATE NOT NULL,
  `cargo` INT NOT NULL,
  `fechaIngreso` DATE NOT NULL,
  `salarioAnual` INT NOT NULL,
  `idOficina` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `dni` (`dni` ASC, `idOficina` ASC) VISIBLE,
  INDEX `idOficina` (`idOficina` ASC) VISIBLE,
  CONSTRAINT `fk_platilla_directores`
    FOREIGN KEY (`id`)
    REFERENCES `casoestudio2`.`directores` (`id`),
  CONSTRAINT `platilla_ibfk_1`
    FOREIGN KEY (`idOficina`)
    REFERENCES `casoestudio2`.`oficinas` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`administrativos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`administrativos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `velocidadEscritura` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `administrativos_ibfk_1`
    FOREIGN KEY (`id`)
    REFERENCES `casoestudio2`.`platilla` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`inquilinos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`inquilinos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(20) NOT NULL,
  `direccion` VARCHAR(30) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `tipoInmueble` VARCHAR(10) NOT NULL,
  `ImporteMax` SMALLINT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`propietarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`propietarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(25) NOT NULL,
  `direccion` VARCHAR(30) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `tipoEmpresa` INT NULL DEFAULT NULL,
  `nombreEmpresa` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`inmuebles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`inmuebles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(20) NOT NULL,
  `ciudad` VARCHAR(15) NOT NULL,
  `tipoInmueble` VARCHAR(10) NOT NULL,
  `NumHabitaciones` VARCHAR(2) NOT NULL,
  `precioAlquiler` INT NOT NULL,
  `idEmpleado` INT NOT NULL,
  `idPropietario` INT NOT NULL,
  `idOficina` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idEmpleado` (`idEmpleado` ASC, `idPropietario` ASC) VISIBLE,
  INDEX `fk_inmuebles_oficinas` (`idOficina` ASC) VISIBLE,
  INDEX `fk_inmuebles_propietarios` (`idPropietario` ASC) VISIBLE,
  CONSTRAINT `fk_inmuebles_oficinas`
    FOREIGN KEY (`idOficina`)
    REFERENCES `casoestudio2`.`oficinas` (`id`),
  CONSTRAINT `fk_inmuebles_propietarios`
    FOREIGN KEY (`idPropietario`)
    REFERENCES `casoestudio2`.`propietarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`contrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`contrato` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `importeMensual` INT NOT NULL,
  `MetodoPago` INT NOT NULL,
  `importeDeposito` INT NOT NULL,
  `EstadoDeposito` TINYINT(1) NOT NULL,
  `fechaInicio` DATE NOT NULL,
  `fechaFin` DATE NOT NULL,
  `DuracionContratoMeses` VARCHAR(2) NOT NULL,
  `idEmpleado` INT NOT NULL,
  `IdInquilino` INT NOT NULL,
  `idInmbueble` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idEmpleado` (`idEmpleado` ASC, `IdInquilino` ASC, `idInmbueble` ASC) VISIBLE,
  INDEX `fk_contrato_inmuebles` (`idInmbueble` ASC) VISIBLE,
  INDEX `fk_contrato_clientes` (`IdInquilino` ASC) VISIBLE,
  CONSTRAINT `fk_contrato_clientes`
    FOREIGN KEY (`IdInquilino`)
    REFERENCES `casoestudio2`.`inquilinos` (`id`),
  CONSTRAINT `fk_contrato_inmuebles`
    FOREIGN KEY (`idInmbueble`)
    REFERENCES `casoestudio2`.`inmuebles` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`entrevista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`entrevista` (
  `id` INT NOT NULL,
  `id_empleado` INT NOT NULL,
  `id_inquili` INT NOT NULL,
  `fecha` DATE NOT NULL,
  `comentario` VARCHAR(256) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_entrevista_clientes` (`id_inquili` ASC) VISIBLE,
  CONSTRAINT `fk_entrevista_clientes`
    FOREIGN KEY (`id_inquili`)
    REFERENCES `casoestudio2`.`inquilinos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `casoestudio2`.`factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`factura` (
  `id` INT NOT NULL,
  `importe_fac` VARCHAR(20) NOT NULL,
  `metodo_pago` VARCHAR(20) NOT NULL,
  `importe_deposito` VARCHAR(10) NOT NULL,
  `plazo_pago` DATE NOT NULL,
  `observaciones` VARCHAR(20) NOT NULL,
  `idCliente` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `casoestudio2`.`inmfactura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`inmfactura` (
  `id` INT NOT NULL,
  `idInmueble` INT NOT NULL,
  `idFactura` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_inmbueblefacturas` (`idInmueble` ASC) VISIBLE,
  INDEX `fk_facturas_facturas` (`idFactura` ASC) VISIBLE,
  CONSTRAINT `fk_facturas_facturas`
    FOREIGN KEY (`idFactura`)
    REFERENCES `casoestudio2`.`factura` (`id`),
  CONSTRAINT `fk_inmbueblefacturas`
    FOREIGN KEY (`idInmueble`)
    REFERENCES `casoestudio2`.`inmuebles` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `casoestudio2`.`inspecciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`inspecciones` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `comentario` VARCHAR(256) NOT NULL,
  `idEmpleado` INT NOT NULL,
  `idInmueble` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idInmueble` (`idInmueble` ASC) VISIBLE,
  CONSTRAINT `fk_inspecciones_inmuebles`
    FOREIGN KEY (`idInmueble`)
    REFERENCES `casoestudio2`.`inmuebles` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`pago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`pago` (
  `id` INT NOT NULL,
  `importe` VARCHAR(20) NOT NULL,
  `fecha` DATE NOT NULL,
  `idFactura` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pago_facturas` (`idFactura` ASC) VISIBLE,
  CONSTRAINT `fk_pago_facturas`
    FOREIGN KEY (`idFactura`)
    REFERENCES `casoestudio2`.`factura` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `casoestudio2`.`parientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`parientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(20) NOT NULL,
  `direccion` VARCHAR(25) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `parentesco` VARCHAR(15) NOT NULL,
  `idEmpleado` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idEmpleado` (`idEmpleado` ASC) VISIBLE,
  CONSTRAINT `fk_parientes_empleado`
    FOREIGN KEY (`idEmpleado`)
    REFERENCES `casoestudio2`.`platilla` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`periodico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`periodico` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(20) NOT NULL,
  `dirrecion` VARCHAR(20) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `fax` VARCHAR(10) NULL DEFAULT NULL,
  `nombre_contacto` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `casoestudio2`.`publicidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`publicidad` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `costo` INT NOT NULL,
  `NombrePeriodico` VARCHAR(20) NOT NULL,
  `direccion` VARCHAR(30) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `fax` VARCHAR(10) NULL DEFAULT NULL,
  `idContactoPeriodico` INT NOT NULL,
  `idInmueble` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idContactoPeriodico` (`idContactoPeriodico` ASC) VISIBLE,
  INDEX `fk_publicidad_inmuebles` (`idInmueble` ASC) VISIBLE,
  CONSTRAINT `fk_publicidad_inmuebles`
    FOREIGN KEY (`idInmueble`)
    REFERENCES `casoestudio2`.`inmuebles` (`id`),
  CONSTRAINT `fk_publicidad_periodico`
    FOREIGN KEY (`idContactoPeriodico`)
    REFERENCES `casoestudio2`.`periodico` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `casoestudio2`.`visitas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `casoestudio2`.`visitas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fechaVisita` DATE NOT NULL,
  `idInquilino` INT NOT NULL,
  `comentarios` VARCHAR(512) NOT NULL,
  `idInmueble` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idInquilino` (`idInquilino` ASC, `idInmueble` ASC) VISIBLE,
  INDEX `fk_visitas_inmuebles` (`idInmueble` ASC) VISIBLE,
  CONSTRAINT `fk_visitas_clientes`
    FOREIGN KEY (`idInquilino`)
    REFERENCES `casoestudio2`.`inquilinos` (`id`),
  CONSTRAINT `fk_visitas_inmuebles`
    FOREIGN KEY (`idInmueble`)
    REFERENCES `casoestudio2`.`inmuebles` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
