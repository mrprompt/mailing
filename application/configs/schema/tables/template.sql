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
) ENGINE=InnoDB DEFAULT CHARSET=utf8