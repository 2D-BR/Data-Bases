-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: casoestudio
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrativos`
--

DROP TABLE IF EXISTS `administrativos`;
CREATE TABLE `administrativos` (
  `id_adm` int NOT NULL AUTO_INCREMENT,
  `velocidadEscritura` int NOT NULL,
  PRIMARY KEY (`id_adm`),
  CONSTRAINT `administrativos_ibfk_1` FOREIGN KEY (`id_adm`) REFERENCES `plantilla` (`id_emp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--

--
-- Table structure for table `contrato`
--

DROP TABLE IF EXISTS `contrato`;
CREATE TABLE `contrato` (
  `id_con` int NOT NULL AUTO_INCREMENT,
  `importeMensual` int NOT NULL,
  `MetodoPago` int NOT NULL,
  `importeDeposito` int NOT NULL,
  `EstadoDeposito` tinyint(1) NOT NULL,
  `fechaInicio` date NOT NULL,
  `fechaFin` date NOT NULL,
  `DuracionContratoMeses` varchar(10) NOT NULL,
  `idEmpleado` int NOT NULL,
  `IdInquilino` int NOT NULL,
  `idInmbueble` int NOT NULL,
  PRIMARY KEY (`id_con`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`,`IdInquilino`,`idInmbueble`),
  KEY `fk_contrato_inmuebles` (`idInmbueble`),
  KEY `fk_contrato_clientes` (`IdInquilino`),
  CONSTRAINT `fk_contrato_clientes` FOREIGN KEY (`IdInquilino`) REFERENCES `inquilinos` (`id_inq`),
  CONSTRAINT `fk_contrato_inmuebles` FOREIGN KEY (`idInmbueble`) REFERENCES `inmuebles` (`id_inm`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `directores`
--

DROP TABLE IF EXISTS `directores`;
CREATE TABLE `directores` (
  `id_dir` int NOT NULL AUTO_INCREMENT,
  `pagoAnual` int NOT NULL,
  `bonificaconMensual` int NOT NULL,
  PRIMARY KEY (`id_dir`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--
-- Table structure for table `entrevista`
--

DROP TABLE IF EXISTS `entrevista`;
CREATE TABLE `entrevista` (
  `id_ent` int NOT NULL,
  `id_empleado` int NOT NULL,
  `id_inquilino` int NOT NULL,
  `fecha` date NOT NULL,
  `comentario` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id_ent`),
  KEY `fk_entrevista_clientes` (`id_inquilino`),
  CONSTRAINT `fk_entrevista_clientes` FOREIGN KEY (`id_inquilino`) REFERENCES `inquilinos` (`id_inq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `factura`
--

DROP TABLE IF EXISTS `factura`;
CREATE TABLE `factura` (
  `id_fac` int NOT NULL,
  `importe_fac` varchar(20) NOT NULL,
  `metodo_pago` varchar(20) NOT NULL,
  `importe_deposito` varchar(10) NOT NULL,
  `plazo_pago` date NOT NULL,
  `observaciones` varchar(20) NOT NULL,
  `idCliente` int NOT NULL,
  PRIMARY KEY (`id_fac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `inmfactura`
--

DROP TABLE IF EXISTS `inmfactura`;
CREATE TABLE `inmfactura` (
  `id_inmf` int NOT NULL,
  `idInmueble` int NOT NULL,
  `idFactura` int NOT NULL,
  PRIMARY KEY (`id_inmf`),
  KEY `fk_inmbueblefacturas` (`idInmueble`),
  KEY `fk_facturas_facturas` (`idFactura`),
  CONSTRAINT `fk_facturas_facturas` FOREIGN KEY (`idFactura`) REFERENCES `factura` (`id_fac`),
  CONSTRAINT `fk_inmbueblefacturas` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id_inm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `inmuebles`
--

DROP TABLE IF EXISTS `inmuebles`;
CREATE TABLE `inmuebles` (
  `id_inm` int NOT NULL AUTO_INCREMENT,
  `direccion` varchar(20) NOT NULL,
  `ciudad` varchar(15) NOT NULL,
  `tipoInmueble` varchar(10) NOT NULL,
  `NumHabitaciones` varchar(2) NOT NULL,
  `precioAlquiler` int NOT NULL,
  `idEmpleado` int NOT NULL,
  `idPropietario` int NOT NULL,
  `idOficina` int NOT NULL,
  PRIMARY KEY (`id_inm`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`,`idPropietario`),
  KEY `fk_inmuebles_oficinas` (`idOficina`),
  KEY `fk_inmuebles_propietarios` (`idPropietario`),
  CONSTRAINT `fk_inmuebles_oficinas` FOREIGN KEY (`idOficina`) REFERENCES `oficinas` (`id_ofi`),
  CONSTRAINT `fk_inmuebles_propietarios` FOREIGN KEY (`idPropietario`) REFERENCES `propietarios` (`id_pro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `inquilinos`
--

DROP TABLE IF EXISTS `inquilinos`;
CREATE TABLE `inquilinos` (
  `id_inq` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `tipoInmueble` varchar(10) NOT NULL,
  `ImporteMax` smallint NOT NULL,
  PRIMARY KEY (`id_inq`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `inspecciones`
--

DROP TABLE IF EXISTS `inspecciones`;
CREATE TABLE `inspecciones` (
  `id_ins` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `comentario` varchar(256) NOT NULL,
  `idEmpleado` int NOT NULL,
  `idInmueble` int NOT NULL,
  PRIMARY KEY (`id_ins`),
  UNIQUE KEY `idInmueble` (`idInmueble`),
  CONSTRAINT `fk_inspecciones_inmuebles` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id_inm`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `oficinas`
--

DROP TABLE IF EXISTS `oficinas`;
CREATE TABLE `oficinas` (
  `id_ofi` int NOT NULL AUTO_INCREMENT,
  `direccion` varchar(30) NOT NULL,
  `ciudad` varchar(15) NOT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `telefono` varchar(10) NOT NULL,
  PRIMARY KEY (`id_ofi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
CREATE TABLE `pago` (
  `id_pag` int NOT NULL,
  `importe` varchar(20) NOT NULL,
  `fecha` date NOT NULL,
  `idFactura` int NOT NULL,
  PRIMARY KEY (`id_pag`),
  KEY `fk_pago_facturas` (`idFactura`),
  CONSTRAINT `fk_pago_facturas` FOREIGN KEY (`idFactura`) REFERENCES `factura` (`id_fac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
--

--
-- Table structure for table `parientes`
--

DROP TABLE IF EXISTS `parientes`;
CREATE TABLE `parientes` (
  `id_par` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `direccion` varchar(25) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `parentesco` varchar(15) NOT NULL,
  `idEmpleado` int NOT NULL,
  PRIMARY KEY (`id_par`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`),
  CONSTRAINT `fk_parientes_empleado` FOREIGN KEY (`idEmpleado`) REFERENCES `plantilla` (`id_emp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--

--
-- Table structure for table `periodico`
--

DROP TABLE IF EXISTS `periodico`;
CREATE TABLE `periodico` (
  `id_per` int NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `dirrecion` varchar(20) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `nombre_contacto` varchar(20) NOT NULL,
  PRIMARY KEY (`id_per`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `plantilla`
--

DROP TABLE IF EXISTS `plantilla`;
CREATE TABLE `plantilla` (
  `id_emp` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(10) NOT NULL,
  `nombre` varchar(15) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `fechaNacimiento` date NOT NULL,
  `cargo`  varchar(30) NOT NULL,
  `fechaIngreso` date NOT NULL,
  `salarioAnual` int NOT NULL,
  `idOficina` int NOT NULL,
  PRIMARY KEY (`id_emp`),
  UNIQUE KEY `dni` (`dni`,`idOficina`),
  KEY `idOficina` (`idOficina`),
  CONSTRAINT `fk_plantilla_directores` FOREIGN KEY (`id_emp`) REFERENCES `directores` (`id_dir`),
  CONSTRAINT `plantilla_ibfk_1` FOREIGN KEY (`idOficina`) REFERENCES `oficinas` (`id_ofi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--

--
-- Table structure for table `propietarios`
--

DROP TABLE IF EXISTS `propietarios`;
CREATE TABLE `propietarios` (
  `id_pro` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `tipoEmpresa` int DEFAULT NULL,
  `nombreEmpresa` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id_pro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--

--
-- Table structure for table `publicidad`
--

DROP TABLE IF EXISTS `publicidad`;
CREATE TABLE `publicidad` (
  `id_pub` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `costo` int NOT NULL,
  `NombrePeriodico` varchar(20) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `idContactoPeriodico` int NOT NULL,
  `idInmueble` int NOT NULL,
  PRIMARY KEY (`id_pub`),
  UNIQUE KEY `idContactoPeriodico` (`idContactoPeriodico`),
  KEY `fk_publicidad_inmuebles` (`idInmueble`),
  CONSTRAINT `fk_publicidad_inmuebles` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id_inm`),
  CONSTRAINT `fk_publicidad_periodico` FOREIGN KEY (`idContactoPeriodico`) REFERENCES `periodico` (`id_per`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--

--
-- Table structure for table `visitas`
--

DROP TABLE IF EXISTS `visitas`;

CREATE TABLE `visitas` (
  `id_vis` int NOT NULL AUTO_INCREMENT,
  `fechaVisita` date NOT NULL,
  `idInquilino` int NOT NULL,
  `comentarios` varchar(512) NOT NULL,
  `idInmueble` int NOT NULL,
  PRIMARY KEY (`id_vis`),
  UNIQUE KEY `idInquilino` (`idInquilino`,`idInmueble`),
  KEY `fk_visitas_inmuebles` (`idInmueble`),
  CONSTRAINT `fk_visitas_clientes` FOREIGN KEY (`idInquilino`) REFERENCES `inquilinos` (`id_inq`),
  CONSTRAINT `fk_visitas_inmuebles` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id_inm`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-24 13:37:36
