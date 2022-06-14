-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 14-Jun-2022 às 06:20
-- Versão do servidor: 10.4.11-MariaDB
-- versão do PHP: 7.4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `clinica`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `alterar_atendente` (IN `nome_atendente` VARCHAR(200), `id_atendente` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'UPDATE atendente SET nome_atendente=? WHERE id_atendente=?';
    EXECUTE stmt1 USING nome_atendente, id_atendente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterar_consulta` (IN `fk_medico` INT, `fk_paciente` INT, `fk_status` INT, `data` DATE, `descricao` TEXT, `valor` FLOAT, `id_consulta` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'UPDATE consulta SET fk_medico=?, fk_paciente=?, fk_status=?, data=?, descricao=?, valor=? WHERE id_consulta=?';
    EXECUTE stmt1 USING fk_medico, fk_paciente, fk_status, data, descricao, valor, id_consulta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterar_medico` (IN `nome_medico` VARCHAR(200), `fk_especialidade` INT, `id_medico` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'UPDATE medico SET nome_medico=?, fk_especialidade=? WHERE id_medico=?';
    EXECUTE stmt1 USING nome_medico, fk_especialidade, id_medico;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterar_paciente` (IN `nome_paciente` VARCHAR(200), `rg` VARCHAR(20), `cpf` VARCHAR(20), `telefone` VARCHAR(120), `data_nascimento` DATE, `id_paciente` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'UPDATE paciente SET nome_paciente=?, rg=?, cpf=?, telefone=?, data_nascimento=? WHERE id_paciente = ?';
    EXECUTE stmt1 USING nome_paciente, rg, cpf, telefone, data_nascimento, id_paciente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterar_usuario` (IN `u_email` VARCHAR(200), IN `u_senha` VARCHAR(200), IN `id_usuario` INT)  BEGIN    
IF u_senha != '' THEN
   PREPARE stmt1 FROM 'UPDATE usuario SET email = ?, senha = 		? WHERE id_usuario = ?';
	EXECUTE stmt1 USING u_email, md5(u_senha), id_usuario;
ELSE
   PREPARE stmt1 FROM 'UPDATE usuario SET email = ? WHERE id_usuario = ?';
	EXECUTE stmt1 USING u_email, id_usuario;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apagar_consulta` (IN `id_consulta` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'DELETE FROM consulta WHERE id_consulta = ? AND fk_status != 3';
    	EXECUTE stmt1 USING id_consulta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apagar_usuario` (IN `id_usuario` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'DELETE FROM usuario WHERE id_usuario = ?';
    	EXECUTE stmt1 USING id_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_atendente` (IN `nome_atendente` VARCHAR(200), `email` VARCHAR(200), `senha` VARCHAR(200))  BEGIN    
	CALL cadastrar_usuario(2, email, md5(senha), @usuario);
	PREPARE stmt1 FROM 
    		'INSERT INTO atendente(nome_atendente, fk_usuario) VALUES (?, ?)';
    EXECUTE stmt1 USING nome_atendente,  @usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_consulta` (IN `fk_medico` INT, `fk_paciente` INT, `fk_status` INT, `data` DATE, `descricao` TEXT, `valor` FLOAT)  BEGIN    
	PREPARE stmt1 FROM 
    		'INSERT INTO consulta(fk_medico, fk_paciente, fk_status, data, descricao, valor) VALUES (?, ?, ?, ?, ?, ?)';
    EXECUTE stmt1 USING fk_medico, fk_paciente, fk_status, data, descricao, valor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_medico` (IN `nome_medico` VARCHAR(200), `fk_especialidade` INT, `email` VARCHAR(200), `senha` VARCHAR(200))  BEGIN    
	CALL cadastrar_usuario(3, email, md5(senha), @usuario);
	PREPARE stmt1 FROM 
    		'INSERT INTO medico(nome_medico, fk_especialidade, fk_usuario) VALUES (?, ?, ?)';
    EXECUTE stmt1 USING nome_medico, fk_especialidade, @usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_paciente` (IN `nome_paciente` VARCHAR(200), `email` VARCHAR(200), `senha` VARCHAR(200), `rg` VARCHAR(20), `cpf` VARCHAR(20), `telefone` VARCHAR(120), `data_nascimento` DATE)  BEGIN    
	CALL cadastrar_usuario(1, email, md5(senha), @usuario);
	PREPARE stmt1 FROM 
    		'INSERT INTO paciente(nome_paciente, rg, cpf, telefone, data_nascimento, fk_usuario) VALUES (?, ?, ?, ?, ?, ?)';
    EXECUTE stmt1 USING nome_paciente, rg, cpf, telefone, data_nascimento, @usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_usuario` (IN `u_tipo` INT, `u_email` VARCHAR(200), `u_senha` VARCHAR(200), OUT `id_usuario` INT)  BEGIN    
	PREPARE stmt1 FROM 
    	'INSERT INTO usuario (email, senha, fk_tipo) VALUES (?, ?, ?)';
    EXECUTE stmt1 USING u_email, u_senha, u_tipo;
	SET id_usuario = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_atendente` (IN `id` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'SELECT * FROM atendente AS a 
            JOIN usuario AS u ON u.id_usuario=a.fk_usuario 
            JOIN tipo_usuario AS t ON t.id_tipo = u.fk_tipo
            WHERE a.fk_usuario = ?';
    	EXECUTE stmt1 USING id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_medico` (IN `id` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'SELECT * FROM medico AS m 
            JOIN usuario AS u ON u.id_usuario=m.fk_usuario 
            JOIN especialidade AS e ON e.id_especialidade=m.fk_especialidade
            JOIN tipo_usuario AS t ON t.id_tipo = u.fk_tipo
            WHERE m.fk_usuario = ?';
    	EXECUTE stmt1 USING id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_paciente` (IN `id` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'SELECT * FROM paciente AS p 
            JOIN usuario AS u ON u.id_usuario=p.fk_usuario 
            JOIN tipo_usuario AS t ON t.id_tipo = u.fk_tipo
            WHERE p.fk_usuario = ?';
    	EXECUTE stmt1 USING id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_consultas_medico` (IN `id_medico` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'SELECT c.*, p.nome_paciente, m.nome_medico, s.status
            FROM consulta AS c 
            JOIN paciente AS p ON p.id_paciente = c.fk_paciente
            JOIN medico AS M ON m.id_medico = c.fk_medico
            JOIN status AS s ON s.id_status = c.fk_status 
            WHERE m.id_medico = ?
            ORDER BY c.data DESC';
    	EXECUTE stmt1 USING id_medico;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_consultas_paciente` (IN `id_paciente` INT)  BEGIN    
	PREPARE stmt1 FROM 
    		'SELECT c.*, p.nome_paciente, m.nome_medico, s.status
            FROM consulta AS c 
            JOIN paciente AS p ON p.id_paciente = c.fk_paciente
            JOIN medico AS M ON m.id_medico = c.fk_medico
            JOIN status AS s ON s.id_status = c.fk_status 
            WHERE p.id_paciente = ?
            ORDER BY c.data DESC';
    	EXECUTE stmt1 USING id_paciente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `u_email` VARCHAR(200), `u_senha` VARCHAR(200))  BEGIN    
	PREPARE stmt1 FROM 
    		'SELECT id_usuario, fk_tipo FROM usuario WHERE email = ? AND senha = ? LIMIT 1';
    	EXECUTE stmt1 USING u_email, md5(u_senha);
END$$

--
-- Funções
--
CREATE DEFINER=`root`@`localhost` FUNCTION `lucro_consultas` (`data1` DATE, `data2` DATE) RETURNS VARCHAR(255) CHARSET utf8mb4 BEGIN

RETURN (
    SELECT SUM(valor) AS total 
    FROM consulta
    WHERE fk_status = 3 AND 
    data BETWEEN data1 AND data2
);

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `atendente`
--

CREATE TABLE `atendente` (
  `id_atendente` int(11) NOT NULL,
  `nome_atendente` varchar(255) NOT NULL,
  `fk_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `atendente`
--

INSERT INTO `atendente` (`id_atendente`, `nome_atendente`, `fk_usuario`) VALUES
(1, 'atendente1', 9);

-- --------------------------------------------------------

--
-- Estrutura da tabela `consulta`
--

CREATE TABLE `consulta` (
  `id_consulta` int(11) NOT NULL,
  `fk_paciente` int(11) NOT NULL,
  `fk_medico` int(11) NOT NULL,
  `data` date NOT NULL,
  `descricao` text DEFAULT NULL,
  `fk_status` int(11) NOT NULL,
  `valor` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `consulta`
--

INSERT INTO `consulta` (`id_consulta`, `fk_paciente`, `fk_medico`, `data`, `descricao`, `fk_status`, `valor`) VALUES
(3, 2, 1, '2022-06-20', 'sddsdf', 3, 300),
(4, 1, 1, '2022-06-08', 'sada', 3, 433),
(5, 1, 1, '2022-06-07', 'erfwr', 3, 100),
(8, 1, 1, '0000-00-00', 'fgth', 1, 444),
(9, 1, 1, '2022-06-24', 'fgth', 1, 444),
(10, 3, 1, '2022-06-13', 'dfdfgdgfdgdg', 1, 542);

-- --------------------------------------------------------

--
-- Estrutura da tabela `especialidade`
--

CREATE TABLE `especialidade` (
  `id_especialidade` int(11) NOT NULL,
  `especialidade` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `especialidade`
--

INSERT INTO `especialidade` (`id_especialidade`, `especialidade`) VALUES
(1, 'Especialista em Cardiologia'),
(2, 'Especialista em Cirurgia Geral'),
(3, 'Especialista em Cirurgia Vascular'),
(4, 'Especialista em Cirurgia Pediátrica'),
(5, 'Especialista em Dermatologia'),
(6, 'Especialista em Genética Médica');

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `listar_consultas`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `listar_consultas` (
`id_consulta` int(11)
,`fk_paciente` int(11)
,`fk_medico` int(11)
,`data` date
,`descricao` text
,`fk_status` int(11)
,`valor` float
,`nome_paciente` varchar(200)
,`nome_medico` varchar(200)
,`status` varchar(255)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `listar_especialidades`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `listar_especialidades` (
`id_especialidade` int(11)
,`especialidade` varchar(200)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `listar_medicos`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `listar_medicos` (
`id_medico` int(11)
,`nome_medico` varchar(200)
,`fk_especialidade` int(11)
,`fk_usuario` int(11)
,`id_usuario` int(11)
,`email` varchar(200)
,`senha` varchar(200)
,`fk_tipo` int(11)
,`id_especialidade` int(11)
,`especialidade` varchar(200)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `listar_pacientes`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `listar_pacientes` (
`id_paciente` int(11)
,`nome_paciente` varchar(200)
,`rg` varchar(20)
,`cpf` varchar(20)
,`telefone` varchar(20)
,`data_nascimento` date
,`fk_usuario` int(11)
,`id_usuario` int(11)
,`email` varchar(200)
,`senha` varchar(200)
,`fk_tipo` int(11)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `listar_status`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `listar_status` (
`id_status` int(11)
,`status` varchar(255)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `medico`
--

CREATE TABLE `medico` (
  `id_medico` int(11) NOT NULL,
  `nome_medico` varchar(200) NOT NULL,
  `fk_especialidade` int(11) NOT NULL,
  `fk_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `medico`
--

INSERT INTO `medico` (`id_medico`, `nome_medico`, `fk_especialidade`, `fk_usuario`) VALUES
(1, 'DR FULANO', 1, 8),
(2, 'Medico 1', 6, 10);

-- --------------------------------------------------------

--
-- Estrutura da tabela `paciente`
--

CREATE TABLE `paciente` (
  `id_paciente` int(11) NOT NULL,
  `nome_paciente` varchar(200) NOT NULL,
  `rg` varchar(20) NOT NULL,
  `cpf` varchar(20) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `data_nascimento` date NOT NULL,
  `fk_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `paciente`
--

INSERT INTO `paciente` (`id_paciente`, `nome_paciente`, `rg`, `cpf`, `telefone`, `data_nascimento`, `fk_usuario`) VALUES
(1, 'paciente', '123211113', '1231232222221', '1231244431', '2002-12-12', 5),
(2, 'teste', '13394534985', '34721934', '34999994', '0000-00-00', NULL),
(3, 'Paciente 1', '11111111111', '222222222222', '3333333333333', '1998-01-15', 11);

-- --------------------------------------------------------

--
-- Estrutura da tabela `status`
--

CREATE TABLE `status` (
  `id_status` int(11) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `status`
--

INSERT INTO `status` (`id_status`, `status`) VALUES
(1, 'pendente'),
(2, 'pago'),
(3, 'finalizado');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipo_usuario`
--

CREATE TABLE `tipo_usuario` (
  `id_tipo` int(11) NOT NULL,
  `tipo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `tipo_usuario`
--

INSERT INTO `tipo_usuario` (`id_tipo`, `tipo`) VALUES
(1, 'paciente'),
(2, 'atendente'),
(3, 'medico');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `email` varchar(200) NOT NULL,
  `senha` varchar(200) NOT NULL,
  `fk_tipo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `email`, `senha`, `fk_tipo`) VALUES
(5, 'teste@gmail', '81dc9bdb52d04dc20036dbd8313ed055', 1),
(8, 'nikollas@gmail', '81dc9bdb52d04dc20036dbd8313ed055', 3),
(9, 'atendente@gmail', '81dc9bdb52d04dc20036dbd8313ed055', 2),
(10, 'medico1@gmail', '81dc9bdb52d04dc20036dbd8313ed055', 3),
(11, 'paciente1@gmail', '81dc9bdb52d04dc20036dbd8313ed055', 1);

-- --------------------------------------------------------

--
-- Estrutura para vista `listar_consultas`
--
DROP TABLE IF EXISTS `listar_consultas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listar_consultas`  AS  select `c`.`id_consulta` AS `id_consulta`,`c`.`fk_paciente` AS `fk_paciente`,`c`.`fk_medico` AS `fk_medico`,`c`.`data` AS `data`,`c`.`descricao` AS `descricao`,`c`.`fk_status` AS `fk_status`,`c`.`valor` AS `valor`,`p`.`nome_paciente` AS `nome_paciente`,`m`.`nome_medico` AS `nome_medico`,`s`.`status` AS `status` from (((`consulta` `c` join `paciente` `p` on(`p`.`id_paciente` = `c`.`fk_paciente`)) join `medico` `m` on(`m`.`id_medico` = `c`.`fk_medico`)) join `status` `s` on(`s`.`id_status` = `c`.`fk_status`)) order by `c`.`data` desc ;

-- --------------------------------------------------------

--
-- Estrutura para vista `listar_especialidades`
--
DROP TABLE IF EXISTS `listar_especialidades`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listar_especialidades`  AS  select `especialidade`.`id_especialidade` AS `id_especialidade`,`especialidade`.`especialidade` AS `especialidade` from `especialidade` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `listar_medicos`
--
DROP TABLE IF EXISTS `listar_medicos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listar_medicos`  AS  select `m`.`id_medico` AS `id_medico`,`m`.`nome_medico` AS `nome_medico`,`m`.`fk_especialidade` AS `fk_especialidade`,`m`.`fk_usuario` AS `fk_usuario`,`u`.`id_usuario` AS `id_usuario`,`u`.`email` AS `email`,`u`.`senha` AS `senha`,`u`.`fk_tipo` AS `fk_tipo`,`e`.`id_especialidade` AS `id_especialidade`,`e`.`especialidade` AS `especialidade` from ((`medico` `m` join `usuario` `u` on(`u`.`id_usuario` = `m`.`fk_usuario`)) join `especialidade` `e` on(`e`.`id_especialidade` = `m`.`fk_especialidade`)) order by `m`.`nome_medico` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `listar_pacientes`
--
DROP TABLE IF EXISTS `listar_pacientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listar_pacientes`  AS  select `p`.`id_paciente` AS `id_paciente`,`p`.`nome_paciente` AS `nome_paciente`,`p`.`rg` AS `rg`,`p`.`cpf` AS `cpf`,`p`.`telefone` AS `telefone`,`p`.`data_nascimento` AS `data_nascimento`,`p`.`fk_usuario` AS `fk_usuario`,`u`.`id_usuario` AS `id_usuario`,`u`.`email` AS `email`,`u`.`senha` AS `senha`,`u`.`fk_tipo` AS `fk_tipo` from (`paciente` `p` join `usuario` `u` on(`u`.`id_usuario` = `p`.`fk_usuario`)) order by `p`.`nome_paciente` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `listar_status`
--
DROP TABLE IF EXISTS `listar_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listar_status`  AS  select `status`.`id_status` AS `id_status`,`status`.`status` AS `status` from `status` order by `status`.`status` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `atendente`
--
ALTER TABLE `atendente`
  ADD PRIMARY KEY (`id_atendente`),
  ADD KEY `fk_usuario` (`fk_usuario`);

--
-- Índices para tabela `consulta`
--
ALTER TABLE `consulta`
  ADD PRIMARY KEY (`id_consulta`),
  ADD KEY `consulta_ibfk_1` (`fk_status`),
  ADD KEY `consulta_ibfk_2` (`fk_paciente`),
  ADD KEY `consulta_ibfk_3` (`fk_medico`);

--
-- Índices para tabela `especialidade`
--
ALTER TABLE `especialidade`
  ADD PRIMARY KEY (`id_especialidade`);

--
-- Índices para tabela `medico`
--
ALTER TABLE `medico`
  ADD PRIMARY KEY (`id_medico`),
  ADD KEY `fk_especialidade` (`fk_especialidade`),
  ADD KEY `fk_usuario` (`fk_usuario`);

--
-- Índices para tabela `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`id_paciente`),
  ADD KEY `fk_usuario` (`fk_usuario`);

--
-- Índices para tabela `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id_status`);

--
-- Índices para tabela `tipo_usuario`
--
ALTER TABLE `tipo_usuario`
  ADD PRIMARY KEY (`id_tipo`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `fk_tipo` (`fk_tipo`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `atendente`
--
ALTER TABLE `atendente`
  MODIFY `id_atendente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `consulta`
--
ALTER TABLE `consulta`
  MODIFY `id_consulta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `medico`
--
ALTER TABLE `medico`
  MODIFY `id_medico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `paciente`
--
ALTER TABLE `paciente`
  MODIFY `id_paciente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `status`
--
ALTER TABLE `status`
  MODIFY `id_status` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tipo_usuario`
--
ALTER TABLE `tipo_usuario`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `atendente`
--
ALTER TABLE `atendente`
  ADD CONSTRAINT `atendente_ibfk_1` FOREIGN KEY (`fk_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Limitadores para a tabela `consulta`
--
ALTER TABLE `consulta`
  ADD CONSTRAINT `consulta_ibfk_1` FOREIGN KEY (`fk_status`) REFERENCES `status` (`id_status`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `consulta_ibfk_2` FOREIGN KEY (`fk_paciente`) REFERENCES `paciente` (`id_paciente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `consulta_ibfk_3` FOREIGN KEY (`fk_medico`) REFERENCES `medico` (`id_medico`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `medico`
--
ALTER TABLE `medico`
  ADD CONSTRAINT `medico_ibfk_2` FOREIGN KEY (`fk_especialidade`) REFERENCES `especialidade` (`id_especialidade`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `medico_ibfk_3` FOREIGN KEY (`fk_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Limitadores para a tabela `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`fk_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Limitadores para a tabela `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`fk_tipo`) REFERENCES `tipo_usuario` (`id_tipo`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
