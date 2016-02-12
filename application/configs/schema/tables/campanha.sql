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
  `int_status` set('0','1','2','3') DEFAULT '0',
  PRIMARY KEY (`id_campanha`,`id_empresa`,`id_template`,`id_prioridade`),
  KEY `fk_campanha_empresa` (`id_empresa`),
  KEY `fk_campanha_template` (`id_template`),
  CONSTRAINT `fk_campanha_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_campanha_template` FOREIGN KEY (`id_template`) REFERENCES `template` (`id_template`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8