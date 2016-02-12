-- MySQL dump 10.13  Distrib 5.5.29, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mailing_empresas
-- ------------------------------------------------------
-- Server version	5.5.27-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `campanha`
--

DROP TABLE IF EXISTS `campanha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `campanha` (
  `id_campanha` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) unsigned NOT NULL,
  `id_template` int(11) unsigned NOT NULL,
  `id_prioridade` int(11) NOT NULL DEFAULT '1',
  `str_titulo` varchar(255) NOT NULL,
  `dat_criacao` datetime NOT NULL,
  `dat_atualizacao` datetime NOT NULL,
  `dat_inicio` datetime DEFAULT '0000-00-00 00:00:00',
  `dat_fim` datetime DEFAULT '0000-00-00 00:00:00',
  `int_status` set('0','1','2','3') DEFAULT '1',
  PRIMARY KEY (`id_campanha`,`id_empresa`,`id_template`,`id_prioridade`),
  KEY `fk_campanha_empresa` (`id_empresa`),
  KEY `fk_campanha_template` (`id_template`),
  CONSTRAINT `fk_campanha_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_campanha_template` FOREIGN KEY (`id_template`) REFERENCES `template` (`id_template`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `campanha`
--

LOCK TABLES `campanha` WRITE;
/*!40000 ALTER TABLE `campanha` DISABLE KEYS */;
/*!40000 ALTER TABLE `campanha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email` (
  `id_email` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_email_grupo` int(10) unsigned NOT NULL,
  `id_empresa` int(11) unsigned NOT NULL,
  `str_nome` varchar(160) DEFAULT NULL,
  `str_email` varchar(255) NOT NULL,
  `str_hash` varchar(200) NOT NULL,
  `dat_log` datetime DEFAULT '0000-00-00 00:00:00',
  `int_status` set('0','1','2','3') DEFAULT '0',
  PRIMARY KEY (`id_email`,`id_empresa`,`id_email_grupo`),
  UNIQUE KEY `str_hash_UNIQUE` (`str_hash`),
  KEY `fk_email_empresa` (`id_empresa`),
  KEY `fk_email_grupo` (`id_email_grupo`),
  CONSTRAINT `fk_email_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_email_grupo` FOREIGN KEY (`id_email_grupo`) REFERENCES `email_grupo` (`id_email_grupo`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8399065 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email`
--

LOCK TABLES `email` WRITE;
/*!40000 ALTER TABLE `email` DISABLE KEYS */;
/*!40000 ALTER TABLE `email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_grupo`
--

DROP TABLE IF EXISTS `email_grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_grupo` (
  `id_email_grupo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_empresa` int(10) unsigned NOT NULL,
  `str_nome` varchar(200) CHARACTER SET latin1 NOT NULL,
  `dat_log` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_email_grupo`,`id_empresa`),
  KEY `fk_grupo_empresa` (`id_empresa`),
  CONSTRAINT `fk_grupo_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_grupo`
--

LOCK TABLES `email_grupo` WRITE;
/*!40000 ALTER TABLE `email_grupo` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_grupo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresa`
--

DROP TABLE IF EXISTS `empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `empresa` (
  `id_empresa` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `str_nome` varchar(255) NOT NULL,
  `str_email` varchar(255) NOT NULL,
  `int_telefone` varchar(11) NOT NULL,
  `int_cep` int(11) NOT NULL,
  `str_api_chave` varchar(255) DEFAULT NULL,
  `str_api_segredo` varchar(255) DEFAULT NULL,
  `dat_cadastro` datetime NOT NULL,
  `int_status` set('0','1','2','3') DEFAULT '0',
  PRIMARY KEY (`id_empresa`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa`
--

LOCK TABLES `empresa` WRITE;
/*!40000 ALTER TABLE `empresa` DISABLE KEYS */;
INSERT INTO `empresa` VALUES (1,'Localhost','postmaster@localhost.localdomain','0000000000',00000000,'a9cf421420f1de80aff6543550c977','b5a578e3b25d480cb935f8a5033a04',NOW(),'1');
/*!40000 ALTER TABLE `empresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fila`
--

DROP TABLE IF EXISTS `fila`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fila` (
  `id_fila` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_campanha` int(11) unsigned NOT NULL,
  `id_email` int(11) unsigned NOT NULL,
  `id_status` int(11) unsigned NOT NULL DEFAULT '1',
  `id_prioridade` int(10) unsigned NOT NULL DEFAULT '1',
  `str_hash` varchar(255) NOT NULL,
  `dat_log` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_fila`,`id_campanha`,`id_email`,`id_status`,`id_prioridade`),
  UNIQUE KEY `str_hash_UNIQUE` (`str_hash`),
  KEY `prioridade` (`id_prioridade`),
  KEY `fk_fila_campanha_id` (`id_campanha`),
  KEY `fk_fila_email_id` (`id_email`),
  KEY `fk_fila_status_id` (`id_status`),
  KEY `fk_fila_prioridade_id` (`id_prioridade`),
  CONSTRAINT `fk_fila_campanha_id` FOREIGN KEY (`id_campanha`) REFERENCES `campanha` (`id_campanha`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_fila_email_id` FOREIGN KEY (`id_email`) REFERENCES `email` (`id_email`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_fila_prioridade_id` FOREIGN KEY (`id_prioridade`) REFERENCES `fila_prioridade` (`id_prioridade`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_fila_status_id` FOREIGN KEY (`id_status`) REFERENCES `fila_status` (`id_status`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila`
--

LOCK TABLES `fila` WRITE;
/*!40000 ALTER TABLE `fila` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fila_prioridade`
--

DROP TABLE IF EXISTS `fila_prioridade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fila_prioridade` (
  `id_prioridade` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `str_prioridade` varchar(45) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`id_prioridade`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_prioridade`
--

LOCK TABLES `fila_prioridade` WRITE;
/*!40000 ALTER TABLE `fila_prioridade` DISABLE KEYS */;
INSERT INTO `fila_prioridade` VALUES (1,'Baixa'),(2,'Média'),(3,'Alta');
/*!40000 ALTER TABLE `fila_prioridade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fila_status`
--

DROP TABLE IF EXISTS `fila_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fila_status` (
  `id_status` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `str_status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_status`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fila_status`
--

LOCK TABLES `fila_status` WRITE;
/*!40000 ALTER TABLE `fila_status` DISABLE KEYS */;
INSERT INTO `fila_status` VALUES (1,'Inserido'),(2,'Enviando'),(3,'Enviado'),(4,'Rejeitado'),(5,'Lido'),(6,'Erro desconhecido');
/*!40000 ALTER TABLE `fila_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template`
--

DROP TABLE IF EXISTS `template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template` (
  `id_template` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) unsigned NOT NULL,
  `str_nome` varchar(255) NOT NULL DEFAULT 'default',
  `str_titulo` varchar(255) NOT NULL,
  `str_corpo` longtext NOT NULL,
  `dat_criacao` datetime NOT NULL,
  `dat_atualizacao` datetime NOT NULL,
  `int_default` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_template`,`id_empresa`),
  KEY `fk_empresa_id` (`id_empresa`),
  CONSTRAINT `fk_empresa_id` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template`
--

LOCK TABLES `template` WRITE;
/*!40000 ALTER TABLE `template` DISABLE KEYS */;
INSERT INTO `template` VALUES (30,7,'teste','teste','<html>\r\n	<head>\r\n		<title></title>\r\n	</head>\r\n	<body>\r\n		<p>\r\n			Oi {$nome}</p>\r\n	</body>\r\n</html>\r\n',NOW(),NOW(),0);
/*!40000 ALTER TABLE `template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario` (
  `id_usuario` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_empresa` int(11) unsigned NOT NULL,
  `id_usuario_nivel` int(10) unsigned NOT NULL DEFAULT '3',
  `str_nome` varchar(120) DEFAULT NULL,
  `str_email` varchar(200) NOT NULL,
  `str_senha` varchar(120) NOT NULL,
  `int_status` set('0','1','2','3') DEFAULT '0',
  `int_admin` tinyint(4) DEFAULT '0',
  `dat_cadastro` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_usuario`,`id_empresa`,`id_usuario_nivel`),
  UNIQUE KEY `str_email_UNIQUE` (`str_email`),
  KEY `fk_usuario_empresa` (`id_empresa`),
  KEY `fk_usuario_nivel` (`id_usuario_nivel`),
  CONSTRAINT `fk_usuario_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_nivel` FOREIGN KEY (`id_usuario_nivel`) REFERENCES `usuario_nivel` (`id_usuario_nivel`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,1,2,'Administrador','admin@localhost.localdomain','c5d691df0ba067ecfd79d707da4438cbbbf1fdcc','1',0,NOW());
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_nivel`
--

DROP TABLE IF EXISTS `usuario_nivel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario_nivel` (
  `id_usuario_nivel` int(10) unsigned NOT NULL,
  `str_nivel` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_usuario_nivel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_nivel`
--

LOCK TABLES `usuario_nivel` WRITE;
/*!40000 ALTER TABLE `usuario_nivel` DISABLE KEYS */;
INSERT INTO `usuario_nivel` VALUES (1,'Super usuário'),(2,'Administrador'),(3,'Usuário');
/*!40000 ALTER TABLE `usuario_nivel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'mailing'
--

--
-- Dumping routines for database 'mailing'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_conta_caracteres` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_conta_caracteres`(
	 CARACTER VARCHAR( 255 )
	,STRING TEXT
) RETURNS bigint(20)
    DETERMINISTIC
BEGIN
	RETURN ( LENGTH( STRING ) - LENGTH( REPLACE( STRING, CARACTER, '') ) ) / LENGTH( CARACTER );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_get_elemento_por_indice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_get_elemento_por_indice`(
	 fn_in_txt_lista     LONGTEXT
	,fn_in_str_separador VARCHAR( 50)
	,fn_in_int_indice    BIGINT
) RETURNS longtext CHARSET latin1
    DETERMINISTIC
BEGIN
	IF
		fn_conta_caracteres( fn_in_str_separador, fn_in_txt_lista ) + 1 < fn_in_int_indice
		OR
		fn_in_int_indice < 1
	THEN
		RETURN NULL;
	ELSE
		RETURN SUBSTRING_INDEX( SUBSTRING_INDEX( fn_in_txt_lista, fn_in_str_separador, fn_in_int_indice ), fn_in_str_separador, -1 );
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_is_number` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_is_number`(
    val varchar(255)
) RETURNS tinyint(4)
    DETERMINISTIC
BEGIN
    RETURN val REGEXP '^(-|\\+){0,1}([0-9]+\\.[0-9]*|[0-9]*\\.[0-9]+|[0-9]+)$';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_mascara_filtro_para_where` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_mascara_filtro_para_where`(
	 sp_in_str_mascara  VARCHAR(2500)
	,sp_in_str_filtro   VARCHAR(2500)
	,sp_in_str_operador VARCHAR(  5)
) RETURNS longtext CHARSET latin1
    DETERMINISTIC
BEGIN
	DECLARE sp_int_indice BIGINT DEFAULT 1;
	DECLARE sp_str_item_mascara VARCHAR(500);
	DECLARE sp_str_item_filtro  VARCHAR(500);
	DECLARE sp_str_where VARCHAR(2500) DEFAULT '';

	IF sp_in_str_mascara = '' OR sp_in_str_filtro = ''
	THEN
		RETURN '';
	ELSE
		WHILE fn_get_elemento_por_indice( sp_in_str_mascara, '|', sp_int_indice ) IS NOT NULL
		DO
			SET sp_str_item_mascara = fn_get_elemento_por_indice( sp_in_str_mascara, '|', sp_int_indice );
			SET sp_str_item_filtro  = fn_get_elemento_por_indice( sp_in_str_filtro , '|', sp_int_indice );
			CASE			
				WHEN sp_str_item_filtro REGEXP '\,'
				THEN
					SET sp_str_item_filtro = REPLACE( CONCAT(' between ',sp_str_item_filtro),',',' and ');
					SET sp_str_item_filtro = CASE WHEN sp_str_item_filtro REGEXP '.*(19[0-9]{2}|2[0-9]{3})-(0[1-9]|1[012])-([123]0|[012][1-9]|31).*'
						THEN
							CONCAT(REPLACE(REPLACE(sp_str_item_filtro,' and ','" and "'),' between ',' between "'),'"')
						ELSE
							sp_str_item_filtro
					END;
				WHEN sp_str_item_mascara LIKE 'int%'
				THEN
					SET sp_str_item_filtro = CONCAT(' like "%',sp_str_item_filtro,'%"');	
				WHEN sp_str_item_mascara LIKE 'id%' OR sp_str_item_mascara LIKE 'flo%' 
				THEN
					SET sp_str_item_filtro = CONCAT(' = ',sp_str_item_filtro);					
				WHEN sp_str_item_filtro REGEXP '^:.+&.+$'
				THEN
					SET sp_str_item_filtro = REPLACE( sp_str_item_filtro, ':', ' between "' );
					SET sp_str_item_filtro = REPLACE( sp_str_item_filtro, '&', '" and "' );
					SET sp_str_item_filtro = CONCAT( sp_str_item_filtro, '"' );
				WHEN sp_str_item_filtro REGEXP '^[^,]+(,[^,]+)*$'
				THEN
					SET sp_str_item_filtro = CONCAT( ' like "%', sp_str_item_filtro, '%"' );
					SET sp_str_item_filtro = REPLACE( sp_str_item_filtro, ',', '","' );					
				ELSE
					SET sp_str_item_filtro = 'erro';
			END CASE;
			SET sp_str_where = CONCAT(
				 sp_str_where
				,' ', CASE sp_str_where WHEN '' THEN '' ELSE sp_in_str_operador END, ' '
				,sp_str_item_mascara
				,sp_str_item_filtro
			);
			SET sp_int_indice = sp_int_indice + 1;
		END WHILE;
		SET sp_str_where = CASE sp_str_where WHEN '' THEN '' ELSE CONCAT( ' (', sp_str_where, ')' ) END;
		RETURN IFNULL(sp_str_where,'');
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_regex_replace` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_regex_replace`(
	pattern varchar(1000),
	replacement varchar(1000),
	original varchar(1000)
) RETURNS varchar(1000) CHARSET latin1
    DETERMINISTIC
begin 
 declare temp varchar(1000); 
 declare ch varchar(1); 
 declare i int;
 set i = 1;
 set temp = '';
 if original regexp pattern then 
  loop_label: loop 
   if i>char_length(original) then
    leave loop_label;  
   end if;
   set ch = substring(original,i,1);
   if not ch regexp pattern then
    set temp = concat(temp,ch);
   else
    set temp = concat(temp,replacement);
   end if;
   set i=i+1;
  end loop;
 else
  set temp = original;
 end if;
 return temp;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_somente_numeros` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_somente_numeros`(
	 val VARCHAR( 255 )
) RETURNS varchar(255) CHARSET utf8
    DETERMINISTIC
BEGIN
    DECLARE idx INT DEFAULT 0;
    IF ISNULL(val) THEN RETURN NULL; END IF;
    IF LENGTH(val) = 0 THEN RETURN ""; END IF;

    SET idx = REPLACE(val,".","");
    SET idx = LENGTH(val);

    WHILE idx > 0 DO
        IF fn_is_number(SUBSTRING(val,idx,1)) = 0 THEN
            SET val = REPLACE(val,SUBSTRING(val,idx,1),"");
            SET idx = LENGTH(val)+1;
        END IF;

        SET idx = idx - 1;
    END WHILE;

    RETURN val;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_valida_cnpj` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_valida_cnpj`(
    CNPJ CHAR(20)
) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE _CNPJ varchar (14);
    DECLARE _multiplicador_1 varchar(12);
    DECLARE _multiplicador_2 varchar(13);
     
    DECLARE _resultado int;
    DECLARE _contador int;
     
    DECLARE _digito_1 int;
    DECLARE _digito_2 int;
     
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
          BEGIN
             RETURN 0;
          END;
     
    SET _contador = 1;
    SET _resultado = 0;
    SET _digito_1 = 0;
    SET _digito_2 = 0;
    SET _CNPJ = substring(CNPJ, 1, 12);
     
    SET _multiplicador_1 = '543298765432';
    SET _multiplicador_2 = '6543298765432';
     
      IF(CNPJ IS NULL) THEN
        RETURN NULL;
      END IF;
     
      IF(CHAR_LENGTH(CNPJ) != 14) THEN
        RETURN 0;
      END IF;
     
      WHILE(_contador <= 12) DO
       SET _resultado = _resultado
      + CAST( substring(_CNPJ, _contador, 1) AS UNSIGNED)
      * CAST( substring(_multiplicador_1, _contador, 1) AS UNSIGNED);
       SET _contador = _contador + 1;
      END WHILE;
     
      SET _resultado = _resultado%11;
     
      IF (_resultado < 2)THEN
        SET _digito_1 = 0;
      ELSE
        SET _digito_1 = 11 - _resultado;
      END IF;
     
      SET _CNPJ = CONCAT( _CNPJ, _digito_1);
      SET _contador = 1;
      SET _resultado = 0;
     
      WHILE(_contador <= 13) DO
        SET _resultado = _resultado
      + CAST(substring(_CNPJ, _contador, 1) AS UNSIGNED)
      * CAST(substring(_multiplicador_2, _contador, 1) AS UNSIGNED);
        SET _contador = _contador + 1;
      END WHILE;
     
      SET _resultado = (_resultado%11);
     
      IF(_resultado < 2)THEN
        SET _digito_2 = 0;
      ELSE
        SET _digito_2 = 11 - _resultado;
      END IF;
     
      SET _CNPJ = CONCAT( _CNPJ , _digito_2);
     
      IF(substring(CNPJ, 13, 1) <> _digito_1)
      OR (substring(CNPJ, 14, 1) <> _digito_2) THEN
        RETURN 0;
      END IF;
     
    RETURN 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_valida_cpf` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_valida_cpf`(
	SP_STR_CPF varchar(300)
) RETURNS tinyint(1)
    DETERMINISTIC
begin
	declare valido int(2) default 0;
	declare soma int(10) default 0;
	declare indice int(10) default 0;
	declare dig1 int(10) default 0;
	declare dig2 int(10) default 0;
		
	if length(SP_STR_CPF) = 11 && SP_STR_CPF not in (00000000000, 11111111111, 22222222222, 33333333333,
			44444444444, 55555555555, 66666666666, 77777777777, 88888888888, 99999999999) then
			
			
			set soma = 0;
			set indice = 1;
			while (indice <= 9) do
	 			set soma = soma + cast(substring(SP_STR_CPF,indice,1) as unsigned) * (11 - indice);
	 			set indice = indice + 1;
	 		END while;
	 		set dig1 = 11 - (soma % 11);
	 		if (dig1 > 9) THEN
				set dig1 = 0;
			end if;
	
			
			set soma = 0;
			set indice = 1;
			while (indice <= 10) DO 			
				set soma = soma + cast(substring(SP_STR_CPF,indice,1) AS UNSIGNED) * (12 - indice); 			
				set indice = indice + 1;
	 		end while;
			set dig2 = 11 - (soma % 11);
	 		if dig2 > 9 THEN
				set dig2 = 0;
			end if;
	
			
			if (dig1 = substring(SP_STR_CPF,length(SP_STR_CPF)-1,1)) AND (dig2 = substring(SP_STR_CPF,length(SP_STR_CPF),1)) then
				set valido = 1;
				return 1;
			end if;
	end if;
	return 0;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_valida_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 FUNCTION `fn_valida_email`(
    p_email varchar(64)
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    CASE WHEN NOT (SELECT p_email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$')
    THEN
        
        RETURN 0;
    ELSE
        
        RETURN 1;
    END CASE;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_campanha_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_campanha_delete`(
     in  sp_in_id_campanha      tinyint
    ,in  sp_in_id_empresa       tinyint
    ,out sp_out_int_status      tinyint
    ,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;



	set sp_entradas_validas =
            (0 != (
                select count(e.id_empresa)
                from empresa e
                join campanha c on c.id_empresa = e.id_empresa
                where e.id_empresa = sp_in_id_empresa
                and   c.id_campanha = sp_in_id_campanha
                )
            )
    ;



	if sp_entradas_validas then
        
        update campanha set int_status = '0'
        where id_campanha = sp_in_id_campanha
        and id_empresa = sp_in_id_empresa
        limit 1;

        set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
	end if;



	set sp_out_str_status =
		case sp_out_int_status
			when 0 then 'Solicitação efetuada com sucesso.'
			when 1 then 'Entradas inválidas.'
			else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
           sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_campanha_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_campanha_insert`(
     in  sp_in_id_empresa       integer(11)
    ,in  sp_in_id_template      integer(11)
    ,in  sp_in_id_prioridade    integer(11)
    ,in  sp_in_str_titulo       varchar(255)
    ,in  sp_in_dat_inicio       datetime
    ,in  sp_in_dat_fim          datetime
    ,out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
BEGIN




    declare sp_entradas_validas boolean;



    set sp_entradas_validas =
        sp_in_id_empresa > 0
    &&  sp_in_id_template > 0
    &&  sp_in_id_prioridade > 0
    &&  length(sp_in_str_titulo) > 0
    &&  length(sp_in_dat_inicio) > 0
    &&  length(sp_in_dat_fim) > 0
;



    if sp_entradas_validas then
        insert into campanha values (
             null
            ,sp_in_id_empresa
            ,sp_in_id_template
            ,sp_in_id_prioridade
            ,convert(sp_in_str_titulo  USING utf8)
            ,now()
            ,now()
            ,sp_in_dat_inicio
            ,sp_in_dat_fim
            ,'1'
        );

        set sp_out_int_status = 0;
    else
        set sp_out_int_status = 1;
    end if;



	set sp_out_str_status =
            case sp_out_int_status
                when 0 then 'Solicitação efetuada com sucesso.'
                when 1 then 'Entradas inválidas.'
                else 'Status nao inicializado ou nao mapeado.'
            end;

    select sp_out_int_status as int_status,
           sp_out_str_status as str_status,
           last_insert_id() as id_campanha
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_campanha_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_campanha_status`(
     in  sp_in_id_campanha      tinyint
    ,out sp_out_int_status      tinyint
    ,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;
    declare id integer;
    declare descricao varchar(30);
    declare int_done integer default 0;
    declare status   cursor for
        select id_status, str_status
        from fila_status;
    declare continue handler for sqlstate '02000' set int_done = 1;



	set sp_entradas_validas =
        sp_in_id_campanha > 0
    ;



    if sp_entradas_validas then
        open status;

        set @saida = '';

        repeat fetch status into id, descricao;
            if not int_done then
                set @saida = concat(
                     @saida
                    ,descricao
                    ,': '
                    ,(select count(id_fila)
                      from fila
                      where id_campanha = sp_in_id_campanha
                      and id_status     = id)
                    ,'\n'
                );
            end if;
        until int_done end repeat;
        close status;

        select @saida as status;

        set sp_out_int_status = 0;
    else
            set sp_out_int_status = 1;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_campanha_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_campanha_update`(
     in  sp_in_id_campanha      integer(11)
    ,in  sp_in_id_empresa       integer(11)
    ,in  sp_in_id_template      integer(11)
    ,in  sp_in_id_prioridade    integer(11)
    ,in  sp_in_str_titulo       varchar(255)
    ,in  sp_in_dat_inicio       datetime
    ,in  sp_in_dat_fim          datetime
    ,out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;



    set sp_entradas_validas =
        sp_in_id_campanha > 0
    &&  sp_in_id_empresa > 0
    &&  sp_in_id_template > 0
    &&  sp_in_id_prioridade > 0
    &&  length(sp_in_str_titulo) > 0
    &&  length(sp_in_dat_inicio) > 0
    &&  length(sp_in_dat_fim) > 0
;



    if sp_entradas_validas then
        update campanha set
             id_template   = sp_in_id_template
            ,id_prioridade = sp_in_id_prioridade
            ,str_titulo    = sp_in_str_titulo
            ,dat_inicio    = sp_in_dat_inicio
            ,dat_fim       = sp_in_dat_fim
            ,dat_atualizacao = now()
        where
            id_campanha = sp_in_id_campanha
        and id_empresa  = sp_in_id_empresa
        limit 1;

        set sp_out_int_status = @1;
    else
        set sp_out_int_status = 1;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select sp_out_int_status as int_status,
           sp_out_str_status as str_status,
           last_insert_id() as id_campanha
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_campanha_vincula_grupo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_campanha_vincula_grupo`(
     in  sp_in_id_campanha   integer
    ,in  sp_in_str_grupo     varchar(2048)
    ,out sp_out_int_status   tinyint
    ,out sp_out_str_status   varchar(50)
)
begin




    declare sp_entradas_validas boolean;



    set sp_entradas_validas =
        true
    ;



    if sp_entradas_validas then
        set @i      = 1;
        set @limite = LENGTH(sp_in_str_grupo)-LENGTH(REPLACE(sp_in_str_grupo, '|', '')) + 1;

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_str_grupo, '|', @i);

            insert into fila 
                (id_fila, id_campanha, id_email, id_status, id_prioridade, str_hash, dat_log) 
            select 
                null, sp_in_id_campanha, e.id_email, 1, 1, 
                concat(sp_in_id_campanha, '_', e.id_email),
                now()
            from 
                email e 
            where 
                e.id_email_grupo = @r 
            and e.int_status = 1;

            set @i = @i + row_count();
        end while;
        set sp_out_int_status = 0;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select  @i as int_vinculados, 
            sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_email_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_email_delete`(
     in  sp_in_id_empresa   integer
    ,in  sp_in_id_email     text
	,out sp_out_int_status   tinyint
	,out sp_out_str_status   varchar(50)
)
begin




    declare sp_entradas_validas boolean;



	set sp_entradas_validas =
            0 != length(sp_in_id_email)
        &&  0 != (select count(id_empresa) from empresa where id_empresa = sp_in_id_empresa)
    ;



	if sp_entradas_validas then
        
        
        
        
        set @i      = 1;
        set @limite = LENGTH(sp_in_id_email)-LENGTH(REPLACE(sp_in_id_email, '|', '')) + 1;
        set @retorno = '';

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_id_email, '|', @i);

            delete from email where id_email = @r and id_empresa = sp_in_id_empresa limit 1;

            set @i = @i + 1;
        end while;

        set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
	end if;



	set sp_out_str_status =
		case sp_out_int_status
			when 0 then 'Solicitação efetuada com sucesso.'
			when 1 then 'Entradas inválidas.'
			else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_email_grupo_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_email_grupo_update`(
     in  sp_in_id_grupo tinyint
    ,in  sp_in_str_emails varchar(2500)
    ,out sp_out_int_status tinyint
    ,out sp_out_str_status varchar(50)
)
begin




    declare sp_entradas_validas boolean;



    set sp_entradas_validas =
            true
    ;



    if sp_entradas_validas then
        
        
        
        
        set @i       = 1;
        set @limite  = LENGTH(sp_in_str_emails)-LENGTH(REPLACE(sp_in_str_emails, '|', '')) + 1;

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_str_emails, '|', @i);

            update email
            set id_email_grupo = sp_in_id_grupo
            where id_email = @r
            limit 1;

            set @i = @i + 1;
        end while;
        set sp_out_int_status = 0;
    else
		set sp_out_int_status = 1;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_email_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_email_insert`(
     in  sp_in_id_empresa   integer
    ,in  sp_in_id_grupo     integer
    ,in  sp_in_str_emails   text
    ,out sp_out_int_status   tinyint
    ,out sp_out_str_status   varchar(50)
)
begin




    declare sp_entradas_validas boolean;



	set sp_entradas_validas =
            0 != length(sp_in_str_emails)
        &&  sp_in_id_grupo > 0
        &&  0 != (select count(id_empresa) from empresa where id_empresa = sp_in_id_empresa)
    ;



	if sp_entradas_validas then
        
        
        
        
        set @i       = 1;
        set @limite  = LENGTH(sp_in_str_emails)-LENGTH(REPLACE(sp_in_str_emails, '|', '')) + 1;
        set @retorno = '';
        set @data    = date_format(now(), '%Y%m%d%H%i%s');

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_str_emails, '|', @i);

            if 0 != instr(@r, ':') then
                set @nome  = fn_get_elemento_por_indice(@r, ':', 1);
                set @email = fn_get_elemento_por_indice(@r, ':', 2);
            else
                set @nome  = fn_get_elemento_por_indice(@r, ':', 1);
                set @email = fn_get_elemento_por_indice(@r, ':', 1);
            end if;

            set @hash = concat(
                 sp_in_id_empresa
                ,'_'
                ,fn_regex_replace('[^[:alnum:]]', '', @email)
                ,'_'
                ,@data
            );

            insert ignore into email
            values(
                null,
                sp_in_id_grupo,
                sp_in_id_empresa,
                TRIM(@nome),
                TRIM(@email),
                @hash,
                NOW(),
                1
            );

            set @i = @i + 1;
        end while;
        set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
	end if;



	set sp_out_str_status =
		case sp_out_int_status
			when 0 then 'Solicitação efetuada com sucesso.'
			when 1 then 'Entradas inválidas.'
			else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_email_select_por_empresa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_email_select_por_empresa`(
     in  sp_in_id_empresa   integer
	,out sp_out_int_status   tinyint
	,out sp_out_str_status   varchar(50)
)
begin




    declare sp_entradas_validas boolean;
    declare id                  integer;
    declare int_done            integer default 0;
    declare cur_emails          cursor for
        select id_email
        from email
        where   1
        and     id_empresa  = sp_in_id_empresa;
	declare continue handler for sqlstate '02000' set int_done = 1;



	set sp_entradas_validas =
            0 != (select count(id_empresa) from empresa where id_empresa = sp_in_id_empresa)
    ;



	if sp_entradas_validas then
        open cur_emails;

        repeat fetch cur_emails into id;
            if not int_done then
                set @retorno = concat(@retorno, '|', id);
            end if;
        until int_done end repeat;

        close cur_emails;

        select substring(@retorno, 2) as ids_emails;

        set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
	end if;



	set sp_out_str_status =
		case sp_out_int_status
			when 0 then 'Solicitação efetuada com sucesso.'
			when 1 then 'Entradas inválidas.'
			else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_empresa_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_empresa_insert`(
     in  sp_in_str_nome         varchar(255)
    ,in  sp_in_str_email        varchar(200)
    ,in  sp_in_str_senha        varchar(100)
    ,in  sp_in_int_telefone     varchar(20)
    ,in  sp_in_int_cep          varchar(10)
    ,out sp_out_int_status      tinyint
    ,out sp_out_str_status      varchar(120)
)
begin




    declare sp_entradas_validas boolean;



	set sp_entradas_validas =
            0 != length(sp_in_str_nome)
        &&  0 != fn_valida_email(sp_in_str_email)
        &&  0 != length(sp_in_str_senha)
        && 10 = length(fn_somente_numeros(sp_in_int_telefone))
        &&  8 = length(fn_somente_numeros(sp_in_int_cep))
    ;



    if sp_entradas_validas then
        
        set @novo = true;

        if (0 != (select count(id_usuario) from usuario where str_email = sp_in_str_email))
        then
            set sp_out_int_status   = 2;
            set @novo               = false;
        end if;
        

        if @novo = true
        then
            
            insert into empresa
            values(null
                  ,sp_in_str_nome
                  ,sp_in_str_email
                  ,fn_somente_numeros(sp_in_int_telefone)
                  ,fn_somente_numeros(sp_in_int_cep)
                  ,substr(sha1(concat(now(), sp_in_str_email)), 1, 30)
                  ,substr(sha1(concat(now(), sp_in_str_nome, sp_in_int_cep)), 1, 30)
                  ,now()
                  ,'1'
            );
            set @empresa = last_insert_id();

            
            call sp_usuario_insert(
                 @empresa
                ,sp_in_str_nome
                ,sp_in_str_email
                ,sp_in_str_senha
                ,@1
                ,@2
            );

            set sp_out_int_status = 0;
    end if;
    else
            set sp_out_int_status = 1;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            when 2 then 'Já existe um usuário utilizando este e-mail.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_empresa_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_empresa_update`(
     in  sp_in_id_empresa       integer(11)
    ,in  sp_in_str_nome         varchar(255)
    ,in  sp_in_str_email        varchar(200)
    ,in  sp_in_int_telefone     varchar(20)
    ,in  sp_in_int_cep          varchar(10)
    ,out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;



	set sp_entradas_validas =
            0 != sp_in_id_empresa
        &&  0 != length(sp_in_str_nome)
        &&  0 != fn_valida_email(sp_in_str_email)
        && 10 = length(fn_somente_numeros(sp_in_int_telefone))
        &&  8 = length(fn_somente_numeros(sp_in_int_cep))
    ;



	if sp_entradas_validas then
            set @query    = concat(
                'update empresa set '
                ,' str_nome = \'', sp_in_str_nome, '\''
                ,',str_email = \'', sp_in_str_email, '\''
                ,',int_telefone = \'', fn_somente_numeros(sp_in_int_telefone), '\''
                ,',int_cep = \'', fn_somente_numeros(sp_in_int_cep), '\''
                ,' where id_empresa = ', sp_in_id_empresa , ' limit 1;'
            );
            prepare query from @query;
            execute query;

            set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
	end if;



	set sp_out_str_status =
		case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            when 3 then 'CNPJ em uso por outra empresa.'
            else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_busca_por_hash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_fila_busca_por_hash`(
     in  sp_in_str_hash        varchar(255)
	,out sp_out_int_status      tinyint
	,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;




	set sp_entradas_validas =
            length(sp_in_str_hash) > 0
    ;



	if sp_entradas_validas then
                    set @query = concat(
                        'select distinct sql_calc_found_rows '
                        ,  'e.id_empresa, e.str_nome as str_empresa, '
                        ,  'e.int_telefone, e.int_cnpj, e.int_cep, e.str_email as str_empresa_email, '
                        ,  'e.str_logradouro, e.int_numero, e.str_complemento, '
                        ,  'c.*, '
                        ,  'f.*, '
                        ,  's.* '
                        ,'from empresa e '
                        ,'join campanha c on c.id_empresa = e.id_empresa '
                        ,'join fila f on f.id_campanha = c.id_campanha '
                        ,'join status s on f.int_status = s.id_status '
                        ,'where f.str_hash = \'', sp_in_str_hash, '\' '
                        
                        
                        ,'limit 1'
                    );
                    prepare query from @query;
                    execute query;

                    set @vazio = false;

                    select found_rows() as total;

        set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
	end if;



	set sp_out_str_status =
		case sp_out_int_status
			when 0 then 'Solicitação efetuada com sucesso.'
			when 1 then 'Entradas inválidas.'
			else 'Status nao inicializado ou nao mapeado.'
		end;

    

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_fila_insert`(
     in  sp_in_id_campanha   integer
    ,in  sp_in_id_prioridade integer
    ,in  sp_in_str_emails    text
    ,out sp_out_int_status   tinyint
    ,out sp_out_str_status   varchar(50)
)
begin




    declare sp_entradas_validas boolean;



    set sp_entradas_validas =
        length(sp_in_str_emails) != 0
    &&  sp_in_id_campanha > 0
    &&  sp_in_id_prioridade > 0
    ;



    if sp_entradas_validas then
        
        
        
        
        set @i       = 1;
        set @limite  = LENGTH(sp_in_str_emails)-LENGTH(REPLACE(sp_in_str_emails, '|', '')) + 1;
        set @retorno = '';
        set @data    = now();

        while @i <= @limite do
            set @id_email = fn_get_elemento_por_indice(sp_in_str_emails, '|', @i);

            insert ignore into fila values(
                 null
                ,sp_in_id_campanha
                ,@id_email
                ,1
                ,sp_in_id_prioridade
                ,concat(sp_in_id_campanha, '_', @id_email)
                ,@data
            );

            set @i = @i + 1;
        end while;

        set sp_out_int_status = 0;
    else
        set sp_out_int_status = 1;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_select` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_fila_select`(
     in  sp_in_id_status        tinyint
    ,in  sp_in_id_status_novo  tinyint
    ,out sp_out_int_status      tinyint(1)
    ,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;
    declare empresa integer(11);
    declare empresa_nome varchar(255);
    declare empresa_email varchar(255);
    declare campanha integer(11);
    declare campanha_titulo varchar(255);
    declare email integer(11);
    declare email_nome varchar(255);
    declare email_prioridade integer(11);
    declare email_titulo varchar(255);
    declare email_destino varchar(255);
    declare email_conteudo text;
    declare email_hash varchar(255);
    declare status integer(11);
    declare status_nome varchar(255);
    declare done integer default 0;
    declare fila cursor for
        select STRAIGHT_JOIN
               e.id_empresa,
               e.str_nome as str_empresa,
               e.str_email as str_empresa_email,
               f.id_campanha,
               f.id_fila,
               f.id_prioridade,
               t.str_titulo,
               m.str_nome,
               m.str_email,
               t.str_corpo,
               f.str_hash
        from fila f
        inner join campanha c on c.id_campanha = f.id_campanha
        inner join empresa e on c.id_empresa = e.id_empresa
        inner join email m on m.id_email = f.id_email
        inner join template t on t.id_template = c.id_template
        where f.id_status = sp_in_id_status
        and   c.dat_inicio <= now()
        and   c.dat_fim >= now()
        and   c.int_status in ('1', '2', '3')
        limit 1000;
    declare continue handler for sqlstate '02000' set done = 1;



    set sp_entradas_validas =
        sp_in_id_status > 0
    &&  sp_in_id_status_novo > 0
    ;



    if sp_entradas_validas then
        set max_heap_table_size=8467318272;

        drop table if exists fila_tmp;

        create temporary table fila_tmp (
            id_fila integer(11),
            id_prioridade integer(11),
            str_empresa varchar(255),
            str_empresa_email varchar(255),
            id_campanha integer(11),
            str_titulo varchar(255),
            str_email varchar(255),
            str_corpo varchar(48144),
            str_hash varchar(255),
            primary key (id_fila),
            index prioridade (id_prioridade)
        ) engine = memory;

        open fila;
        repeat fetch fila into empresa,
                               empresa_nome,
                               empresa_email,
                               campanha,
                               email,
                               email_prioridade,
                               email_titulo,
                               email_nome,
                               email_destino,
                               email_conteudo,
                               email_hash;
            if not done then
                set @hoje   = date_format(now(), '%d/%m/%Y');
                set @hora   = date_format(now(), '%H:%i');

                set @titulo = email_titulo;
                set @titulo = replace(@titulo, '{$nome}',   email_nome);
                set @titulo = replace(@titulo, '{$hoje}',   @hoje);
                set @titulo = replace(@titulo, '{$email}',  email_destino);

                set @corpo = email_conteudo;
                set @corpo = replace(@corpo, '{$nome}',     email_nome);
                set @corpo = replace(@corpo, '{$hoje}',     @hoje);
                set @corpo = replace(@corpo, '{$email}',    email_destino);

                insert into fila_tmp values(
                    email,
                    email_prioridade,
                    empresa_nome,
                    empresa_email,
                    campanha,
                    @titulo,
                    email_destino,
                    convert(@corpo using utf8),
                    email_hash
                );
            end if;
        until done end repeat;
        close fila;

        select *
        from fila_tmp
        order by id_prioridade desc;

        update fila f
        inner join fila_tmp t on f.id_fila = t.id_fila
        set f.id_status = sp_in_id_status_novo
        where f.id_status = sp_in_id_status;

        drop table if exists fila_tmp;

        set sp_out_int_status = 0;
    else
            set sp_out_int_status = 1;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'sp_fila_select: Solicitação efetuada com sucesso.'
            when 1 then 'sp_fila_select: Entradas inválidas.'
            else 'sp_fila_select: Status nao inicializado ou nao mapeado.'
        end;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_fila_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_fila_update`(
     in  sp_in_id_campanha tinyint
    ,in  sp_in_str_id_fila varchar(2500)
    ,in  sp_in_int_status  tinyint
    ,out sp_out_int_status tinyint
    ,out sp_out_str_status varchar(50)
)
begin




    declare sp_entradas_validas boolean;
    declare id                  int;
    declare titulo              varchar(255);
    declare email               varchar(255);
    declare corpo               text;



	set sp_entradas_validas =
            (0 != (select count(id_campanha) from campanha where id_campanha = sp_in_id_campanha))
;



    if sp_entradas_validas then
        
        update fila f
        inner join fila_tmp t on f.id_fila = t.id_fila
        set f.id_status = sp_in_id_status_novo
        where f.id_status = sp_in_id_status;

        set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
    end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select sp_out_int_status as int_status,
           sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_status`(dbname varchar(50))
begin

(
    select
     TABLE_NAME as `Table Name`,
     ENGINE as `Engine`,
     TABLE_ROWS as `Rows`,
     concat(
        (format((DATA_LENGTH + INDEX_LENGTH) / power(1024,2),2))
        , ' Mb')
       as `Size`,
     TABLE_COLLATION as `Collation`
    from information_schema.TABLES
    where TABLES.TABLE_SCHEMA = dbname
          and TABLES.TABLE_TYPE = 'BASE TABLE'
)
union
(
    select
     TABLE_NAME as `Table Name`,
     '[VIEW]' as `Engine`,
     '-' as `Rows`,
     '-' `Size`,
     '-' as `Collation`
    from information_schema.TABLES
    where TABLES.TABLE_SCHEMA = dbname
          and TABLES.TABLE_TYPE = 'VIEW'
)
order by 1;

(
    select ROUTINE_NAME as `Routine Name`,
     ROUTINE_TYPE as `Type`,
     '' as `Comment`
    from information_schema.ROUTINES
    where ROUTINE_SCHEMA = dbname
    order by ROUTINES.ROUTINE_TYPE, ROUTINES.ROUTINE_NAME
)
union
(
    select TRIGGER_NAME,'TRIGGER' as `Type`,
    concat('On ',EVENT_MANIPULATION,': ',EVENT_OBJECT_TABLE) as `Comment`
    from information_schema.TRIGGERS
    where EVENT_OBJECT_SCHEMA = dbname
)
order by 2,1;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_usuario_insert`(
     in  sp_in_int_empresa      integer(11)
    ,in  sp_in_str_nome         varchar(120)
    ,in  sp_in_str_email        varchar(200)
    ,in  sp_in_str_senha        varchar(100)
    ,out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;




	set sp_entradas_validas =
            0 != sp_in_int_empresa
        &&  0 != fn_valida_email(sp_in_str_email)
        &&  0 != length(sp_in_str_senha)
    ;



	if sp_entradas_validas then
        
        set @novo = true;

        if (0 != (select count(id_usuario) from usuario where str_email = sp_in_str_email))
        then
            set sp_out_int_status   = 2;
            set @novo               = false;
        end if;
        

        if @novo = true
        then
            
            set @query = concat(
                'insert into usuario values('
                ,'null'
                ,',\'', sp_in_int_empresa ,'\''
                ,',\'2\''
                ,',\'', sp_in_str_nome ,'\''
                ,',\'', sp_in_str_email ,'\''
                ,',\'', sha1(sp_in_str_senha) ,'\''
                ,',\'', 1 ,'\''
                ,',\'', 0 ,'\''
                ,',\'', now() ,'\''
                ,');'
            );

            prepare query from @query;
            execute query;

            set sp_out_int_status = 0;
        end if;
	else
		set sp_out_int_status = 1;
	end if;



    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            when 2 then 'E-mail já cadastrado.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/  /*!50003 PROCEDURE `sp_usuario_login`(
     in  sp_in_str_email        varchar(200)
    ,in  sp_in_str_senha        varchar(120)
    ,out sp_out_int_status      tinyint
    ,out sp_out_str_status      varchar(50)
)
begin




    declare sp_entradas_validas boolean;




	set sp_entradas_validas =
            0 != fn_valida_email(sp_in_str_email)
        &&  0 != length(sp_in_str_senha)
    ;



	if sp_entradas_validas then
        
        if (1 = (select count(id_usuario) from usuario
                 where str_email = sp_in_str_email
                 and str_senha = sha1(sp_in_str_senha) limit 1))
        then
            set sp_out_int_status = 0;
        else
            set sp_out_int_status = 2;
        end if;
	else
		set sp_out_int_status = 1;
	end if;



	set sp_out_str_status =
		case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            when 2 then 'E-mail/senha inválidos.'
            else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
           sp_out_str_status as str_status
    ;

    if (sp_out_int_status = 0) then
        select u.*
        from   usuario u
        where  u.str_email = sp_in_str_email;

        select e.*
        from   empresa e
        join   usuario u on e.id_empresa = u.id_empresa
        where  u.str_email = sp_in_str_email
        limit 1;
    end if;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-20  3:15:14
