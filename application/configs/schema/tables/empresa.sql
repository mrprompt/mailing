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
) ENGINE=InnoDB DEFAULT CHARSET=utf8