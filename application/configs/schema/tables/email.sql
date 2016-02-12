CREATE TABLE `email` (
  `id_email` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_email_grupo` int(11) unsigned NOT NULL,
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
  CONSTRAINT `fk_email_grupo` FOREIGN KEY (`id_email_grupo`) REFERENCES `email_grupo` (`id_email_grupo`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_email_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7277582 DEFAULT CHARSET=utf8