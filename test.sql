# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.19)
# Database: falcon_portal
# Generation Time: 2017-10-12 02:36:39 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table action
# ------------------------------------------------------------

CREATE TABLE `action` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uic` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `callback` tinyint(4) NOT NULL DEFAULT '0',
  `before_callback_sms` tinyint(4) NOT NULL DEFAULT '0',
  `before_callback_mail` tinyint(4) NOT NULL DEFAULT '0',
  `after_callback_sms` tinyint(4) NOT NULL DEFAULT '0',
  `after_callback_mail` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table alert_link
# ------------------------------------------------------------

CREATE TABLE `alert_link` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `content` text COLLATE utf8_unicode_ci NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `alert_path` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table cluster
# ------------------------------------------------------------

CREATE TABLE `cluster` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grp_id` int(11) NOT NULL,
  `numerator` varchar(10240) COLLATE utf8_unicode_ci NOT NULL,
  `denominator` varchar(10240) COLLATE utf8_unicode_ci NOT NULL,
  `endpoint` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `metric` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `tags` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `ds_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `step` int(11) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creator` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table expression
# ------------------------------------------------------------

CREATE TABLE `expression` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `expression` varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  `func` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'all(#1)',
  `op` varchar(8) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `right_value` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `max_step` int(11) NOT NULL DEFAULT '1',
  `priority` tinyint(4) NOT NULL DEFAULT '0',
  `note` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `action_id` int(10) unsigned NOT NULL DEFAULT '0',
  `create_user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `pause` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table grp
# ------------------------------------------------------------

CREATE TABLE `grp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grp_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `create_user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `come_from` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_host_grp_grp_name` (`grp_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table grp_host
# ------------------------------------------------------------

CREATE TABLE `grp_host` (
  `grp_id` int(10) unsigned NOT NULL,
  `host_id` int(10) unsigned NOT NULL,
  KEY `idx_grp_host_grp_id` (`grp_id`),
  KEY `idx_grp_host_host_id` (`host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table grp_tpl
# ------------------------------------------------------------

CREATE TABLE `grp_tpl` (
  `grp_id` int(10) unsigned NOT NULL,
  `tpl_id` int(10) unsigned NOT NULL,
  `bind_user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  KEY `idx_grp_tpl_grp_id` (`grp_id`),
  KEY `idx_grp_tpl_tpl_id` (`tpl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table host
# ------------------------------------------------------------

CREATE TABLE `host` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `ip` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `agent_version` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `plugin_version` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `maintain_begin` int(10) unsigned NOT NULL DEFAULT '0',
  `maintain_end` int(10) unsigned NOT NULL DEFAULT '0',
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_host_hostname` (`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table mockcfg
# ------------------------------------------------------------

CREATE TABLE `mockcfg` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'name of mockcfg, used for uuid',
  `obj` varchar(10240) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'desc of object',
  `obj_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'type of object, host or group or other',
  `metric` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `tags` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `dstype` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'GAUGE',
  `step` int(11) unsigned NOT NULL DEFAULT '60',
  `mock` double NOT NULL DEFAULT '0' COMMENT 'mocked value when nodata occurs',
  `creator` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `t_create` datetime NOT NULL COMMENT 'create time',
  `t_modify` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'last modify time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table plugin_dir
# ------------------------------------------------------------

CREATE TABLE `plugin_dir` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grp_id` int(10) unsigned NOT NULL,
  `dir` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `create_user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_plugin_dir_grp_id` (`grp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table strategy
# ------------------------------------------------------------

CREATE TABLE `strategy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `metric` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `tags` varchar(256) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `max_step` int(11) NOT NULL DEFAULT '1',
  `priority` tinyint(4) NOT NULL DEFAULT '0',
  `func` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'all(#1)',
  `op` varchar(8) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `right_value` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `note` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `run_begin` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `run_end` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `tpl_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_strategy_tpl_id` (`tpl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table tpl
# ------------------------------------------------------------

CREATE TABLE `tpl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tpl_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `action_id` int(10) unsigned NOT NULL DEFAULT '0',
  `create_user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_tpl_name` (`tpl_name`),
  KEY `idx_tpl_create_user` (`create_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
