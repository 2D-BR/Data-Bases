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
  `id` int NOT NULL AUTO_INCREMENT,
  `velocidadEscritura` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `administrativos_ibfk_1` FOREIGN KEY (`id`) REFERENCES `platilla` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contrato`
--

DROP TABLE IF EXISTS `contrato`;
CREATE TABLE `contrato` (
  `id` int NOT NULL AUTO_INCREMENT,
  `importeMensual` int NOT NULL,
  `MetodoPago` int NOT NULL,
  `importeDeposito` int NOT NULL,
  `EstadoDeposito` tinyint(1) NOT NULL,
  `fechaInicio` date NOT NULL,
  `fechaFin` date NOT NULL,
  `DuracionContratoMeses` varchar(2) NOT NULL,
  `idEmpleado` int NOT NULL,
  `IdInquilino` int NOT NULL,
  `idInmbueble` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`,`IdInquilino`,`idInmbueble`),
  KEY `fk_contrato_inmuebles` (`idInmbueble`),
  KEY `fk_contrato_clientes` (`IdInquilino`),
  CONSTRAINT `fk_contrato_clientes` FOREIGN KEY (`IdInquilino`) REFERENCES `inquilinos` (`id`),
  CONSTRAINT `fk_contrato_inmuebles` FOREIGN KEY (`idInmbueble`) REFERENCES `inmuebles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directores`
--

DROP TABLE IF EXISTS `directores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `directores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pagoAnual` int NOT NULL,
  `bonificaconMensual` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entrevista`
--

DROP TABLE IF EXISTS `entrevista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrevista` (
  `id` int NOT NULL,
  `id_empleado` int NOT NULL,
  `id_inquili` int NOT NULL,
  `fecha` date NOT NULL,
  `comentario` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_entrevista_clientes` (`id_inquili`),
  CONSTRAINT `fk_entrevista_clientes` FOREIGN KEY (`id_inquili`) REFERENCES `inquilinos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `factura`
--

DROP TABLE IF EXISTS `factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura` (
  `id` int NOT NULL,
  `importe_fac` varchar(20) NOT NULL,
  `metodo_pago` varchar(20) NOT NULL,
  `importe_deposito` varchar(10) NOT NULL,
  `plazo_pago` date NOT NULL,
  `observaciones` varchar(20) NOT NULL,
  `idCliente` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inmfactura`
--

DROP TABLE IF EXISTS `inmfactura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inmfactura` (
  `id` int NOT NULL,
  `idInmueble` int NOT NULL,
  `idFactura` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_inmbueblefacturas` (`idInmueble`),
  KEY `fk_facturas_facturas` (`idFactura`),
  CONSTRAINT `fk_facturas_facturas` FOREIGN KEY (`idFactura`) REFERENCES `factura` (`id`),
  CONSTRAINT `fk_inmbueblefacturas` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inmuebles`
--

DROP TABLE IF EXISTS `inmuebles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inmuebles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `direccion` varchar(20) NOT NULL,
  `ciudad` varchar(15) NOT NULL,
  `tipoInmueble` varchar(10) NOT NULL,
  `NumHabitaciones` varchar(2) NOT NULL,
  `precioAlquiler` int NOT NULL,
  `idEmpleado` int NOT NULL,
  `idPropietario` int NOT NULL,
  `idOficina` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`,`idPropietario`),
  KEY `fk_inmuebles_oficinas` (`idOficina`),
  KEY `fk_inmuebles_propietarios` (`idPropietario`),
  CONSTRAINT `fk_inmuebles_oficinas` FOREIGN KEY (`idOficina`) REFERENCES `oficinas` (`id`),
  CONSTRAINT `fk_inmuebles_propietarios` FOREIGN KEY (`idPropietario`) REFERENCES `propietarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquilinos`
--

DROP TABLE IF EXISTS `inquilinos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquilinos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `tipoInmueble` varchar(10) NOT NULL,
  `ImporteMax` smallint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inspecciones`
--

DROP TABLE IF EXISTS `inspecciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspecciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `comentario` varchar(256) NOT NULL,
  `idEmpleado` int NOT NULL,
  `idInmueble` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idInmueble` (`idInmueble`),
  CONSTRAINT `fk_inspecciones_inmuebles` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oficinas`
--

DROP TABLE IF EXISTS `oficinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oficinas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `direccion` varchar(30) NOT NULL,
  `ciudad` varchar(15) NOT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `telefono` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `id` int NOT NULL,
  `importe` varchar(20) NOT NULL,
  `fecha` date NOT NULL,
  `idFactura` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pago_facturas` (`idFactura`),
  CONSTRAINT `fk_pago_facturas` FOREIGN KEY (`idFactura`) REFERENCES `factura` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `parientes`
--

DROP TABLE IF EXISTS `parientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `direccion` varchar(25) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `parentesco` varchar(15) NOT NULL,
  `idEmpleado` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`),
  CONSTRAINT `fk_parientes_empleado` FOREIGN KEY (`idEmpleado`) REFERENCES `platilla` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `periodico`
--

DROP TABLE IF EXISTS `periodico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `periodico` (
  `id` int NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `dirrecion` varchar(20) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `nombre_contacto` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `platilla`
--

DROP TABLE IF EXISTS `platilla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platilla` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(10) NOT NULL,
  `nombre` varchar(15) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `fechaNacimiento` date NOT NULL,
  `cargo` int NOT NULL,
  `fechaIngreso` date NOT NULL,
  `salarioAnual` int NOT NULL,
  `idOficina` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`,`idOficina`),
  KEY `idOficina` (`idOficina`),
  CONSTRAINT `fk_platilla_directores` FOREIGN KEY (`id`) REFERENCES `directores` (`id`),
  CONSTRAINT `platilla_ibfk_1` FOREIGN KEY (`idOficina`) REFERENCES `oficinas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `propietarios`
--

DROP TABLE IF EXISTS `propietarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propietarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `tipoEmpresa` int DEFAULT NULL,
  `nombreEmpresa` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publicidad`
--

DROP TABLE IF EXISTS `publicidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicidad` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `costo` int NOT NULL,
  `NombrePeriodico` varchar(20) NOT NULL,
  `direccion` varchar(30) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `idContactoPeriodico` int NOT NULL,
  `idInmueble` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idContactoPeriodico` (`idContactoPeriodico`),
  KEY `fk_publicidad_inmuebles` (`idInmueble`),
  CONSTRAINT `fk_publicidad_inmuebles` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id`),
  CONSTRAINT `fk_publicidad_periodico` FOREIGN KEY (`idContactoPeriodico`) REFERENCES `periodico` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `visitas`
--

DROP TABLE IF EXISTS `visitas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fechaVisita` date NOT NULL,
  `idInquilino` int NOT NULL,
  `comentarios` varchar(512) NOT NULL,
  `idInmueble` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idInquilino` (`idInquilino`,`idInmueble`),
  KEY `fk_visitas_inmuebles` (`idInmueble`),
  CONSTRAINT `fk_visitas_clientes` FOREIGN KEY (`idInquilino`) REFERENCES `inquilinos` (`id`),
  CONSTRAINT `fk_visitas_inmuebles` FOREIGN KEY (`idInmueble`) REFERENCES `inmuebles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-24 13:37:36
