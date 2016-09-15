-- phpMyAdmin SQL Dump
-- version 2.6.2-pl1
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Erstellungszeit: 20. März 2007 um 17:03
-- Server Version: 4.1.13
-- PHP-Version: 5.2.0
-- 
-- Datenbank: `heckmann`
-- 

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `file_types`
-- 

CREATE TABLE `file_types` (
  `id` tinyint(1) NOT NULL default '0',
  `name` tinytext NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle `file_types`
-- 

INSERT INTO `file_types` VALUES (1, 'file');
INSERT INTO `file_types` VALUES (2, 'preview');
INSERT INTO `file_types` VALUES (3, 'enlarged');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `files`
-- 

CREATE TABLE `files` (
  `type` tinyint(4) NOT NULL default '0',
  `mediafile_id` mediumint(4) NOT NULL default '0',
  `src` varchar(200) NOT NULL default '',
  `width` int(4) NOT NULL default '0',
  `height` int(4) NOT NULL default '0',
  `mediatype` varchar(3) NOT NULL default '',
  PRIMARY KEY  (`mediafile_id`,`type`),
  KEY `files_ibfk_2` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle `files`
-- 

INSERT INTO `files` VALUES (1, 1, '../../media/image_01.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 1, '../../media/image_01_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 2, '../../media/image_02.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 2, '../../media/image_02_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 3, '../../media/image_03.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 3, '../../media/image_03_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 4, '../../media/image_04.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 4, '../../media/image_04_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 6, '../../media/image_06.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 6, '../../media/image_06_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 9, '/media\\image_09.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 9, '/media\\image_09_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 10, '/media\\image_10.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 10, '/media\\image_10_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 11, '/media\\image_11.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 11, '/media\\image_11_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 12, '/media\\image_12.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 12, '/media\\image_12_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 13, '/media\\image_13.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 13, '/media\\image_13_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 14, '/media\\image_14.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 14, '/media\\image_14_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 15, '/media\\image_15.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 15, '/media\\image_15_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 16, '/media\\image_16.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 16, '/media\\image_16_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 17, '/media\\image_17.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 17, '/media\\image_17_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 18, '/media\\image_18.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 18, '/media\\image_18_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 19, '/media\\image_19.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 19, '/media\\image_19_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 20, '/media\\image_20.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 20, '/media\\image_20_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 21, '/media\\image_21.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 21, '/media\\image_21_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 22, '/media\\image_22.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 22, '/media\\image_22_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 23, '/media\\image_23.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 23, '/media\\image_23_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 24, '/media\\image_24.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 24, '/media\\image_24_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 25, '/media\\image_25.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 25, '/media\\image_25_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 26, '/media\\image_26.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 26, '/media\\image_26_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 28, '/media\\image_28.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 28, '/media\\image_28_thumb.jpg', 88, 100, 'jpg');
INSERT INTO `files` VALUES (1, 29, '/media\\image_29.jpg', 990, 600, 'jpg');
INSERT INTO `files` VALUES (2, 29, '/media\\image_29_thumb.jpg', 88, 100, 'jpg');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `mediafiles`
-- 

CREATE TABLE `mediafiles` (
  `id` mediumint(9) NOT NULL default '0',
  `copyright` tinytext,
  `caption` mediumtext,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle `mediafiles`
-- 

INSERT INTO `mediafiles` VALUES (1, '', '');
INSERT INTO `mediafiles` VALUES (2, '', '');
INSERT INTO `mediafiles` VALUES (3, '', '');
INSERT INTO `mediafiles` VALUES (4, '', '');
INSERT INTO `mediafiles` VALUES (6, '', '');
INSERT INTO `mediafiles` VALUES (7, NULL, NULL);
INSERT INTO `mediafiles` VALUES (8, NULL, NULL);
INSERT INTO `mediafiles` VALUES (9, NULL, NULL);
INSERT INTO `mediafiles` VALUES (10, NULL, NULL);
INSERT INTO `mediafiles` VALUES (11, NULL, NULL);
INSERT INTO `mediafiles` VALUES (12, NULL, NULL);
INSERT INTO `mediafiles` VALUES (13, NULL, NULL);
INSERT INTO `mediafiles` VALUES (14, NULL, NULL);
INSERT INTO `mediafiles` VALUES (15, NULL, NULL);
INSERT INTO `mediafiles` VALUES (16, NULL, NULL);
INSERT INTO `mediafiles` VALUES (17, NULL, NULL);
INSERT INTO `mediafiles` VALUES (18, NULL, NULL);
INSERT INTO `mediafiles` VALUES (19, NULL, NULL);
INSERT INTO `mediafiles` VALUES (20, NULL, NULL);
INSERT INTO `mediafiles` VALUES (21, NULL, NULL);
INSERT INTO `mediafiles` VALUES (22, NULL, NULL);
INSERT INTO `mediafiles` VALUES (23, NULL, NULL);
INSERT INTO `mediafiles` VALUES (24, NULL, NULL);
INSERT INTO `mediafiles` VALUES (25, NULL, NULL);
INSERT INTO `mediafiles` VALUES (26, NULL, NULL);
INSERT INTO `mediafiles` VALUES (28, NULL, NULL);
INSERT INTO `mediafiles` VALUES (29, NULL, NULL);

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `portfolio_names`
-- 

CREATE TABLE `portfolio_names` (
  `id` mediumint(9) NOT NULL default '0',
  `name` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle `portfolio_names`
-- 

INSERT INTO `portfolio_names` VALUES (1, 'cars');
INSERT INTO `portfolio_names` VALUES (2, 'people');
INSERT INTO `portfolio_names` VALUES (3, 'archive.cars');
INSERT INTO `portfolio_names` VALUES (4, 'archive.people');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle `portfolios`
-- 

CREATE TABLE `portfolios` (
  `id` tinyint(3) NOT NULL default '0',
  `mediafile_id` mediumint(9) NOT NULL default '0',
  `position` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`,`mediafile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle `portfolios`
-- 

INSERT INTO `portfolios` VALUES (1, 1, 2);
INSERT INTO `portfolios` VALUES (1, 2, 0);
INSERT INTO `portfolios` VALUES (1, 3, 3);
INSERT INTO `portfolios` VALUES (1, 11, 4);
INSERT INTO `portfolios` VALUES (1, 12, 5);
INSERT INTO `portfolios` VALUES (1, 13, 6);
INSERT INTO `portfolios` VALUES (1, 14, 7);
INSERT INTO `portfolios` VALUES (1, 15, 8);
INSERT INTO `portfolios` VALUES (1, 16, 9);
INSERT INTO `portfolios` VALUES (1, 17, 10);
INSERT INTO `portfolios` VALUES (1, 28, 11);
INSERT INTO `portfolios` VALUES (2, 4, 1);
INSERT INTO `portfolios` VALUES (2, 6, 2);
INSERT INTO `portfolios` VALUES (2, 18, 3);
INSERT INTO `portfolios` VALUES (2, 19, 4);
INSERT INTO `portfolios` VALUES (2, 20, 5);
INSERT INTO `portfolios` VALUES (2, 21, 6);
INSERT INTO `portfolios` VALUES (2, 22, 7);
INSERT INTO `portfolios` VALUES (2, 23, 8);
INSERT INTO `portfolios` VALUES (2, 24, 9);
INSERT INTO `portfolios` VALUES (2, 25, 0);
INSERT INTO `portfolios` VALUES (2, 26, 10);
INSERT INTO `portfolios` VALUES (3, 9, 1);
INSERT INTO `portfolios` VALUES (3, 10, 2);
INSERT INTO `portfolios` VALUES (3, 29, 0);
        