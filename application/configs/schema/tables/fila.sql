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
  CONSTRAINT `fk_fila_status_id` FOREIGN KEY (`id_status`) REFERENCES `fila_status` (`id_status`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_fila_prioridade_id` FOREIGN KEY (`id_prioridade`) REFERENCES `fila_prioridade` (`id_prioridade`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6487966 DEFAULT CHARSET=utf8