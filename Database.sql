-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.6.24 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for api-kelas-siswa
CREATE DATABASE IF NOT EXISTS `api-kelas-siswa` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `api-kelas-siswa`;

-- Dumping structure for function api-kelas-siswa.add_kelas_siswa
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `add_kelas_siswa`(
	`kelas` VARCHAR(50),
	`siswa` VARCHAR(50) 
) RETURNS int(11)
BEGIN 
DECLARE JML,STS INT; 
SET JML=0;
SET STS=0;
SELECT COUNT(*) INTO JML FROM kelas_siswa WHERE bPengguna = siswa AND bKelas = kelas;
IF JML > 0 THEN 
	SET STS = 1;
ELSE
	INSERT INTO `kelas_siswa` (`bKelasSiswa`, `bPengguna`, `bKelas`) VALUES (UPPER(UUID()),siswa,kelas); 
END IF;
RETURN STS;
END//
DELIMITER ;

-- Dumping structure for function api-kelas-siswa.add_role_pengguna
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `add_role_pengguna`(
	`pengguna` VARCHAR(50),
	`role` VARCHAR(50)
) RETURNS int(11)
BEGIN
DECLARE JML,STS INT;
DECLARE UID_ROLE VARCHAR(50);
SET JML=0;
SET STS=0;
SELECT COUNT(*) INTO JML FROM master_role WHERE cRole = role;
IF JML > 0 THEN
	SELECT bRole INTO UID_ROLE FROM master_role WHERE cRole = role LIMIT 1;
	INSERT INTO `pengguna_role` (`bPenggunaRole`, `bPenguna`, `bRole`) VALUES (UPPER(UUID()), pengguna, UID_ROLE);
ELSE
	SET STS = 1;
END IF;
RETURN STS;
END//
DELIMITER ;

-- Dumping structure for function api-kelas-siswa.create_token
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `create_token`(
	`idpengguna` VARCHAR(50)
) RETURNS text CHARSET latin1
BEGIN
DECLARE TOKEN,TOKENENCRIPT,DATETOKEN,GABUNGTOKEN,KEYPERSONAL varchar(100); 
SET KEYPERSONAL = "ACHMADARIESPIRNANDO20200215";
SELECT CONCAT(idpengguna,KEYPERSONAL,SYSDATE()) INTO TOKEN;
SET DATETOKEN =REPLACE(REPLACE(REPLACE(SYSDATE(),"-","")," ",""),":","");
SET TOKENENCRIPT = UPPER(MD5(MD5(TOKEN))); 
SELECT CONCAT(TOKENENCRIPT,DATETOKEN) INTO GABUNGTOKEN;
UPDATE pengguna SET vToken =GABUNGTOKEN WHERE bPenguna = idpengguna;
RETURN GABUNGTOKEN;
END//
DELIMITER ;

-- Dumping structure for table api-kelas-siswa.kelas_pengajar
CREATE TABLE IF NOT EXISTS `kelas_pengajar` (
  `bKelasPengajar` char(36) NOT NULL,
  `bPengguna` char(36) DEFAULT NULL,
  `bKelas` char(36) DEFAULT NULL,
  `iStatus` tinyint(4) DEFAULT '0' COMMENT '0 Tidak Aktif 1 Aktif',
  `dCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dUpdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `iDeleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`bKelasPengajar`),
  KEY `bPengguna` (`bPengguna`),
  KEY `bKelas` (`bKelas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Dumping data for table api-kelas-siswa.kelas_pengajar: ~4 rows (approximately)
DELETE FROM `kelas_pengajar`;
/*!40000 ALTER TABLE `kelas_pengajar` DISABLE KEYS */;
INSERT INTO `kelas_pengajar` (`bKelasPengajar`, `bPengguna`, `bKelas`, `iStatus`, `dCreated`, `dUpdated`, `iDeleted`) VALUES
	('8533ADF9-44E9-11EA-A482-1063C86166EC', '23C6CD44-44D7-11EA-A482-1063C86186EC', 'C6A3D437-44E7-11EA-A482-1063C86186EC', 1, '2020-02-01 18:53:54', '2020-02-01 18:53:54', 0),
	('8533ADF9-44E9-11EA-A482-1063C86166FC', '63F0F8D8-44DA-11EA-A482-1063C86186EC', 'C6A3D437-44E7-11EA-A482-1063C86186EC', 1, '2020-02-01 18:53:54', '2020-02-01 18:53:54', 0),
	('8533ADF9-44E9-11EA-A482-1063C86186EC', '5ADBBC46-44D1-11EA-A482-1063C86186EC', 'C6A3D437-44E7-11EA-A482-1063C86186EC', 1, '2020-02-01 18:53:54', '2020-02-01 18:53:54', 0),
	('8F270AF7-44E9-11EA-A482-1063C86186EC', '23C6CD44-44D7-11EA-A482-1063C86186EC', 'C6A6EDB4-44E7-11EA-A482-1063C86186EC', 1, '2020-02-01 18:54:10', '2020-02-01 18:54:10', 0);
/*!40000 ALTER TABLE `kelas_pengajar` ENABLE KEYS */;

-- Dumping structure for table api-kelas-siswa.kelas_siswa
CREATE TABLE IF NOT EXISTS `kelas_siswa` (
  `bKelasSiswa` char(36) NOT NULL,
  `bPengguna` char(36) DEFAULT NULL,
  `bKelas` char(36) DEFAULT NULL,
  `iFinished` tinyint(4) DEFAULT '0',
  `iStatus` tinyint(4) DEFAULT '0' COMMENT '0 Tidak Aktif 1 Aktif',
  `dCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dUpdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `iDeleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`bKelasSiswa`),
  KEY `bPengguna` (`bPengguna`),
  KEY `bKelas` (`bKelas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Dumping data for table api-kelas-siswa.kelas_siswa: ~4 rows (approximately)
DELETE FROM `kelas_siswa`;
/*!40000 ALTER TABLE `kelas_siswa` DISABLE KEYS */;
INSERT INTO `kelas_siswa` (`bKelasSiswa`, `bPengguna`, `bKelas`, `iFinished`, `iStatus`, `dCreated`, `dUpdated`, `iDeleted`) VALUES
	('8533ADF9-44E9-11EA-A482-1063C86166EC', '23C6CD44-44D7-11EA-A482-1063C86186EC', 'C6A3D437-44E7-11EA-A482-1063C86186EC', 0, 1, '2020-02-01 18:53:54', '2020-02-01 18:53:54', 0),
	('8533ADF9-44E9-11EA-A482-1063C86166FC', '63F0F8D8-44DA-11EA-A482-1063C86186EC', 'C6A3D437-44E7-11EA-A482-1063C86186EC', 0, 1, '2020-02-01 18:53:54', '2020-02-01 18:53:54', 0),
	('8533ADF9-44E9-11EA-A482-1063C86186EC', '5ADBBC46-44D1-11EA-A482-1063C86186EC', 'C6A3D437-44E7-11EA-A482-1063C86186EC', 0, 1, '2020-02-01 18:53:54', '2020-02-01 18:53:54', 0),
	('8F270AF7-44E9-11EA-A482-1063C86186EC', '23C6CD44-44D7-11EA-A482-1063C86186EC', 'C6A6EDB4-44E7-11EA-A482-1063C86186EC', 0, 1, '2020-02-01 18:54:10', '2020-02-01 18:54:10', 0);
/*!40000 ALTER TABLE `kelas_siswa` ENABLE KEYS */;

-- Dumping structure for procedure api-kelas-siswa.login_pengguna
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_pengguna`(
	IN `username` VARCHAR(50),
	IN `password` VARCHAR(50)
)
BEGIN
SELECT IFNULL(bPenguna, '-'), IFNULL(vNoHandphone, '-'), IFNULL(vNamaPengguna, '-'), IFNULL(vEmail, '-'), IFNULL(vUsername, '-'),IFNULL(iStatus, '-') 
FROM pengguna WHERE vPassword = MD5(password) AND (vUsername = username OR vEmail = username) AND iStatus <> 2 AND iDeleted = 0;
END//
DELIMITER ;

-- Dumping structure for procedure api-kelas-siswa.logout_pengguna
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `logout_pengguna`(
	IN `idpengguna` VARCHAR(50),
	IN `token` TEXT
)
BEGIN
UPDATE pengguna SET vToken =null WHERE bPenguna = idpengguna AND vToken = token;
END//
DELIMITER ;

-- Dumping structure for table api-kelas-siswa.master_kelas
CREATE TABLE IF NOT EXISTS `master_kelas` (
  `bKelas` char(36) NOT NULL,
  `cKelas` char(10) DEFAULT NULL,
  `vNamaKelas` varchar(50) DEFAULT NULL,
  `tKeterangan` text,
  `iStatus` tinyint(4) DEFAULT '0' COMMENT '0 Tidak Aktif 1 Aktif',
  `dCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dUpdated` datetime DEFAULT NULL,
  `iDeleted` tinyint(4) DEFAULT '0',
  `eKelas` enum('Online','Offline') DEFAULT 'Online',
  PRIMARY KEY (`bKelas`),
  KEY `cKelas` (`cKelas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table api-kelas-siswa.master_kelas: ~4 rows (approximately)
DELETE FROM `master_kelas`;
/*!40000 ALTER TABLE `master_kelas` DISABLE KEYS */;
INSERT INTO `master_kelas` (`bKelas`, `cKelas`, `vNamaKelas`, `tKeterangan`, `iStatus`, `dCreated`, `dUpdated`, `iDeleted`, `eKelas`) VALUES
	('C6A3D437-44E7-11EA-A482-1063C86186EC', 'TI-API', 'Membuat CRUD Dasar dengan menggunakan REST API bah', '', 1, '2020-02-01 18:41:24', NULL, 0, 'Online'),
	('C6A58A16-44E7-11EA-A482-1063C86186EC', 'TI-GOLANG', 'Memahami konsep dasar bahasa pemrograman Golang', '', 1, '2020-02-01 18:41:24', NULL, 0, 'Online'),
	('C6A6EDB4-44E7-11EA-A482-1063C86186EC', 'TI-JAVA', 'Memahami konsep dasar bahasa pemrograman Java', '', 1, '2020-02-01 18:41:24', NULL, 0, 'Online'),
	('C6A848A4-44E7-11EA-A482-1063C86186EC', 'TI-PHP', 'Memahami konsep dasar bahasa pemrograman PHP', '', 1, '2020-02-01 18:41:24', NULL, 0, 'Online');
/*!40000 ALTER TABLE `master_kelas` ENABLE KEYS */;

-- Dumping structure for table api-kelas-siswa.master_materi_kelas
CREATE TABLE IF NOT EXISTS `master_materi_kelas` (
  `bMateriKelas` char(36) NOT NULL,
  `iPreview` tinyint(4) NOT NULL,
  `bKelas` char(36) DEFAULT NULL,
  `vVideo` varchar(50) DEFAULT NULL,
  `tKeterangan` text,
  `iSequence` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 Tidak Aktif 1 Aktif',
  `dCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dUpdated` datetime DEFAULT NULL,
  `iDeleted` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`bMateriKelas`),
  KEY `bKelas` (`bKelas`),
  KEY `iPreview` (`iPreview`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Dumping data for table api-kelas-siswa.master_materi_kelas: ~5 rows (approximately)
DELETE FROM `master_materi_kelas`;
/*!40000 ALTER TABLE `master_materi_kelas` DISABLE KEYS */;
INSERT INTO `master_materi_kelas` (`bMateriKelas`, `iPreview`, `bKelas`, `vVideo`, `tKeterangan`, `iSequence`, `dCreated`, `dUpdated`, `iDeleted`) VALUES
	('6AB32533-4FAB-11EA-9990-1063C86186EC', 0, 'C6A3D437-44E7-11EA-A482-1063C86186EC', 'Link Video 1', 'Link Video Keterangan 1', 0, '2020-02-15 11:27:03', NULL, 0),
	('707BBC1C-4FAB-11EA-9990-1063C86186EC', 0, 'C6A3D437-44E7-11EA-A482-1063C86186EC', 'Link Video 2', 'Link Video Keterangan 2', 1, '2020-02-15 11:27:13', NULL, 0),
	('737B9E7A-4FAB-11EA-9990-1063C86186EC', 0, 'C6A3D437-44E7-11EA-A482-1063C86186EC', 'Link Video 3', 'Link Video Keterangan 3', 2, '2020-02-15 11:27:18', NULL, 0),
	('775406EF-4FAB-11EA-9990-1063C86186EC', 1, 'C6A3D437-44E7-11EA-A482-1063C86186EC', 'Link Video 4', 'Link Video Keterangan 3', 3, '2020-02-15 11:27:24', NULL, 0),
	('797C3D11-4FAB-11EA-9990-1063C86186EC', 1, 'C6A3D437-44E7-11EA-A482-1063C86186EC', 'Link Video 4', 'Link Video Keterangan 3', 4, '2020-02-15 11:27:28', NULL, 0);
/*!40000 ALTER TABLE `master_materi_kelas` ENABLE KEYS */;

-- Dumping structure for table api-kelas-siswa.master_role
CREATE TABLE IF NOT EXISTS `master_role` (
  `bRole` char(36) NOT NULL,
  `cRole` char(6) DEFAULT NULL,
  `vNamaRole` varchar(50) DEFAULT NULL,
  `tKeterangan` text,
  PRIMARY KEY (`bRole`),
  KEY `cRole` (`cRole`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table api-kelas-siswa.master_role: ~4 rows (approximately)
DELETE FROM `master_role`;
/*!40000 ALTER TABLE `master_role` DISABLE KEYS */;
INSERT INTO `master_role` (`bRole`, `cRole`, `vNamaRole`, `tKeterangan`) VALUES
	('3EFD32A6-44D1-11EA-A482-1063C86186EC', 'RL_PGN', 'RULE PENGGUNA', NULL),
	('44EC15E3-44D1-11EA-A482-1063C86186EC', 'RL_ADM', 'RULE ADMIN', NULL),
	('4D3BFC9C-44D1-11EA-A482-1063C86186EC', 'RL_PJR', 'RULE PENGAJAR', NULL);
/*!40000 ALTER TABLE `master_role` ENABLE KEYS */;

-- Dumping structure for table api-kelas-siswa.pengguna
CREATE TABLE IF NOT EXISTS `pengguna` (
  `bPenguna` char(36) NOT NULL,
  `vNamaPengguna` varchar(50) DEFAULT NULL,
  `vUserName` varchar(50) DEFAULT NULL,
  `vPassword` varchar(50) DEFAULT NULL,
  `vEmail` varchar(50) NOT NULL,
  `vNoHandphone` varchar(20) DEFAULT NULL,
  `tAlamat` text,
  `dCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `iStatus` tinyint(4) DEFAULT '0' COMMENT '0 InAktif 1 Aktif 2 NonAktif',
  `cTokenVer` char(6) DEFAULT NULL,
  `iDeleted` tinyint(4) DEFAULT '0',
  `vUpdated` varchar(30) DEFAULT NULL,
  `dUpdated` datetime DEFAULT NULL,
  `vToken` text,
  PRIMARY KEY (`bPenguna`),
  KEY `vUserName` (`vUserName`),
  KEY `iStatus` (`iStatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table api-kelas-siswa.pengguna: ~3 rows (approximately)
DELETE FROM `pengguna`;
/*!40000 ALTER TABLE `pengguna` DISABLE KEYS */;
INSERT INTO `pengguna` (`bPenguna`, `vNamaPengguna`, `vUserName`, `vPassword`, `vEmail`, `vNoHandphone`, `tAlamat`, `dCreated`, `iStatus`, `cTokenVer`, `iDeleted`, `vUpdated`, `dUpdated`, `vToken`) VALUES
	('23C6CD44-44D7-11EA-A482-1063C86186EC', 'Aini Rahmayati', 'ainirahmayati', '81dc9bdb52d04dc20036dbd8313ed055', 'ainirahamayati95@gmail.com', '082178547981', 'Jakarta Barat', '2020-02-01 16:42:19', 1, NULL, 0, NULL, NULL, NULL),
	('5ADBBC46-44D1-11EA-A482-1063C86186EC', 'Achmad Aries Pirnando', 'ariespirnando', '81dc9bdb52d04dc20036dbd8313ed055', 'aries.pirnando@gmail.com', NULL, 'Jakarta Selatan', '2020-02-01 16:00:55', 1, NULL, 0, NULL, NULL, NULL),
	('63F0F8D8-44DA-11EA-A482-1063C86186EC', 'SUWONDO', 'SUWONDO', '81dc9bdb52d04dc20036dbd8313ed055', 'SUWONDO@gmail.com', '081122334455', 'LIWA', '2020-02-01 17:05:35', 1, NULL, 0, NULL, NULL, NULL);
/*!40000 ALTER TABLE `pengguna` ENABLE KEYS */;

-- Dumping structure for table api-kelas-siswa.pengguna_role
CREATE TABLE IF NOT EXISTS `pengguna_role` (
  `bPenggunaRole` char(36) NOT NULL,
  `bPenguna` char(36) NOT NULL,
  `bRole` char(36) DEFAULT NULL,
  `dCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `iDeleted` tinyint(4) DEFAULT '0',
  `vUpdated` varchar(30) DEFAULT NULL,
  `dUpdated` datetime DEFAULT NULL,
  PRIMARY KEY (`bPenggunaRole`),
  KEY `bPenguna` (`bPenguna`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Dumping data for table api-kelas-siswa.pengguna_role: ~5 rows (approximately)
DELETE FROM `pengguna_role`;
/*!40000 ALTER TABLE `pengguna_role` DISABLE KEYS */;
INSERT INTO `pengguna_role` (`bPenggunaRole`, `bPenguna`, `bRole`, `dCreated`, `iDeleted`, `vUpdated`, `dUpdated`) VALUES
	('23C6D2EA-44D7-11EA-A482-1063C86186EC', '23C6CD44-44D7-11EA-A482-1063C86186EC', '3EFD32A6-44D1-11EA-A482-1063C86186EC', '2020-02-01 16:42:19', 0, NULL, NULL),
	('5ADBC16D-44D1-11EA-A412-1063C86186AC', '5ADBBC46-44D1-11EA-A482-1063C86186EC', '4D3BFC9C-44D1-11EA-A482-1063C86186EC', '2020-02-01 16:00:55', 0, NULL, NULL),
	('5ADBC16D-44D1-11EA-A482-1063C86186AC', '5ADBBC46-44D1-11EA-A482-1063C86186EC', '3EFD32A6-44D1-11EA-A482-1063C86186EC', '2020-02-01 16:00:55', 0, NULL, NULL),
	('5ADBC16D-44D1-11EA-A482-1063C86186EC', '5ADBBC46-44D1-11EA-A482-1063C86186EC', '44EC15E3-44D1-11EA-A482-1063C86186EC', '2020-02-01 16:00:55', 0, NULL, NULL),
	('63F107C0-44DA-11EA-A482-1063C86186EC', '63F0F8D8-44DA-11EA-A482-1063C86186EC', '3EFD32A6-44D1-11EA-A482-1063C86186EC', '2020-02-01 17:05:35', 0, NULL, NULL);
/*!40000 ALTER TABLE `pengguna_role` ENABLE KEYS */;

-- Dumping structure for function api-kelas-siswa.register_kelas
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `register_kelas`(
	`pengguna` VARCHAR(50),
	`kelas` VARCHAR(50)
) RETURNS int(11)
BEGIN
DECLARE JML, STS INT;
INSERT INTO `kelas_siswa` (`bKelasSiswa`, `bPengguna`, `bKelas`) 
VALUES (UPPER(UUID()), pengguna, kelas);
RETURN 0;
END//
DELIMITER ;

-- Dumping structure for function api-kelas-siswa.register_pengguna
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `register_pengguna`(
	`namapengguna` VARCHAR(50),
	`username` VARCHAR(50),
	`password` VARCHAR(50),
	`email` VARCHAR(50),
	`handphone` VARCHAR(50),
	`alamat` TEXT
) RETURNS int(11)
BEGIN

DECLARE JML,STS,Value INT;
DECLARE UID VARCHAR(50); 

SET STS=0;
SELECT COUNT(*) INTO JML FROM pengguna WHERE (vUserName = username OR vEmail = email OR vNoHandphone=handphone) AND iDeleted =0;

IF JML > 0 THEN
	SET STS=1;
ELSE  
	SET UID=UPPER(UUID());
	SELECT `add_role_pengguna`(UID, 'RL_PGN') AS STS_ROLE INTO JML;
	IF JML > 0 THEN
		SET STS=1;
	ELSE 
		SET Value=LPAD(FLOOR(RAND() * 999999.99), 6, '0');
		INSERT INTO `pengguna` (`bPenguna`, `vNamaPengguna`, `vUserName`, `vPassword`, `vEmail`, `vNoHandphone`, `tAlamat`,cTokenVer) 
		VALUES (UID, namapengguna, username, md5(password), email, handphone, alamat,Value);
	END IF;		
END IF;
RETURN STS;
END//
DELIMITER ;

-- Dumping structure for function api-kelas-siswa.verify_email_pengguna
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `verify_email_pengguna`(
	`email` VARCHAR(50),
	`token` VARCHAR(50)
) RETURNS int(11)
BEGIN
DECLARE STS,JML INT; 
SET STS = 0;
SELECT count(*) INTO JML FROM pengguna WHERE vEmail =email AND cTokenVer = token AND iDeleted=0;
IF JML > 0  THEN
	UPDATE pengguna SET cTokenVer = NULL, iStatus = 1 WHERE vEmail =email AND cTokenVer = token;
ELSE
	SET STS = 1;
END IF;
return STS;
END//
DELIMITER ;

-- Dumping structure for function api-kelas-siswa.verify_token
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `verify_token`(
	`Token` TEXT
) RETURNS int(11)
BEGIN
DECLARE JML,STS INT;
SET STS = 1;
SELECT COUNT(*) INTO JML FROM pengguna WHERE vToken = Token;
IF JML > 0 THEN
	SET STS = 0;
END IF;
RETURN STS;
END//
DELIMITER ;

-- Dumping structure for procedure api-kelas-siswa.view_kelas
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_kelas`(
	IN `pengguna` VARCHAR(50)
)
BEGIN
SELECT IFNULL(mk.bKelas,'-'), IFNULL(mk.cKelas,'-'), IFNULL(mk.vNamaKelas,'-'), IFNULL(mk.tKeterangan,'-'), IFNULL(mk.eKelas,'-'),'TRUE'
	FROM master_kelas mk 
	JOIN kelas_siswa ks on ks.bKelas = mk.bKelas
	WHERE mk.iDeleted = 0 AND mk.iStatus = 1 AND ks.iStatus=1 AND ks.iDeleted=0
	AND ks.bPengguna = pengguna
UNION
SELECT IFNULL(mk.bKelas,'-'), IFNULL(mk.cKelas,'-'), IFNULL(mk.vNamaKelas,'-'), IFNULL(mk.tKeterangan,'-'), IFNULL(mk.eKelas,'-'), 'FALSE'
	FROM master_kelas mk  
	WHERE mk.iDeleted = 0 AND mk.iStatus = 1 
	AND mk.bKelas not in (SELECT IFNULL(mk.bKelas,'-')
								FROM master_kelas mk 
								JOIN kelas_siswa ks on ks.bKelas = mk.bKelas
								WHERE mk.iDeleted = 0 AND mk.iStatus = 1 AND ks.iStatus=1 AND ks.iDeleted=0
								AND ks.bPengguna = pengguna);
END//
DELIMITER ;

-- Dumping structure for procedure api-kelas-siswa.view_kelas_pengajar
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_kelas_pengajar`(
	IN `kelas` VARCHAR(50)
)
BEGIN
SELECT ifnull(p.bPenguna,'-'), ifnull(p.vNamaPengguna,'-'), ifnull(p.vEmail,'-') FROM kelas_pengajar ks JOIN pengguna p on ks.bPengguna = p.bPenguna
where ks.bKelas = kelas AND ks.iStatus=1 AND ks.iDeleted = 0;
END//
DELIMITER ;

-- Dumping structure for procedure api-kelas-siswa.view_kelas_pengguna
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_kelas_pengguna`(
	IN `pengguna` VARCHAR(50)
)
BEGIN
SELECT IFNULL(mk.bKelas,'-'), IFNULL(mk.cKelas,'-'), IFNULL(mk.vNamaKelas,'-'), IFNULL(mk.tKeterangan,'-'), IFNULL(mk.eKelas,'-'),'TRUE'
	FROM master_kelas mk 
	JOIN kelas_siswa ks on ks.bKelas = mk.bKelas
	WHERE mk.iDeleted = 0 AND mk.iStatus = 1 AND ks.iStatus=1 AND ks.iDeleted=0
	AND ks.bPengguna = pengguna;
END//
DELIMITER ;

-- Dumping structure for procedure api-kelas-siswa.view_materi
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_materi`(
	IN `kelas` VARCHAR(50),
	IN `siswa` VARCHAR(50)

)
BEGIN
DECLARE STS INT;
SET STS = 0;
SELECT COUNT(*) INTO STS FROM kelas_siswa WHERE bKelas = kelas AND bPengguna = siswa;
IF STS > 0 THEN
	SELECT 'OPEN' as iPreview, ifnull(vVideo,'-'), ifnull(tKeterangan,'-') FROM master_materi_kelas 
	WHERE iDeleted =0 AND bKelas=kelas ORDER BY iSequence;
ELSE 
	SELECT IF(ifnull(iPreview,'0')=0,'CLOSE','OPEN'), ifnull(vVideo,'-'), ifnull(tKeterangan,'-') FROM master_materi_kelas 
	WHERE iDeleted =0 AND bKelas=kelas ORDER BY iSequence;
END IF; 
END//
DELIMITER ;

-- Dumping structure for procedure api-kelas-siswa.view_role_pengguna
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_role_pengguna`(
	IN `penggunaid` VARCHAR(50)
)
BEGIN
	select IFNULL(`m`.`cRole`, '-') , IFNULL(`m`.`vNamaRole`, '-'), IFNULL(`m`.`bRole`, '-')
	from (`pengguna_role` `p` join `master_role` `m` on((`p`.`bRole` = `m`.`bRole`))) 
	where p.bPenguna = penggunaid AND p.iDeleted =0;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
