CREATE TABLE `email_grupo` (
  `id_email_grupo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_empresa` int(10) unsigned NOT NULL,
  `str_nome` varchar(200) NOT NULL,
  `dat_log` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_email_grupo`,`id_empresa`),
  KEY `fk_grupo_empresa` (`id_empresa`),
  CONSTRAINT `fk_grupo_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1