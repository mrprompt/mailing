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
  CONSTRAINT `fk_usuario_nivel` FOREIGN KEY (`id_usuario_nivel`) REFERENCES `usuario_nivel` (`id_usuario_nivel`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8