-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: dota
-- ------------------------------------------------------
-- Server version	5.1.73

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `activity_score` int(11) NOT NULL COMMENT 'æ´»åŠ¨åˆ†æ•°',
  `amount` int(11) DEFAULT '3' COMMENT 'å‰©ä½™æ¬¡æ•°',
  `buynum` int(11) DEFAULT '1' COMMENT 'è´­ä¹°æ¬¡æ•°',
  `datetime` date DEFAULT NULL COMMENT 'æ—¶é—´',
  `server_id` int(11) DEFAULT NULL COMMENT 'æœåŠ¡å™¨id',
  `last_buy_time` datetime DEFAULT NULL,
  `redward_status` int(11) DEFAULT NULL COMMENT 'æ˜¯å¦é¢†å¥–',
  `version` int(11) DEFAULT NULL COMMENT 'æ´»åŠ¨æ—¶é—´æ®µ',
  `gift_id` varchar(20) DEFAULT NULL COMMENT 'ç¤¼å“id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_pay_double`
--

DROP TABLE IF EXISTS `activity_pay_double`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_pay_double` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `pay_times` int(11) DEFAULT '0',
  `createtime` int(11) DEFAULT '0',
  `updatetime` int(11) DEFAULT '0',
  `during_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_groups_id` int(11) DEFAULT NULL,
  `admin_firstname` varchar(32) NOT NULL DEFAULT '',
  `admin_lastname` varchar(32) DEFAULT NULL,
  `admin_email_address` varchar(96) NOT NULL DEFAULT '',
  `admin_password` varchar(40) NOT NULL DEFAULT '',
  `admin_created` datetime DEFAULT NULL,
  `admin_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `admin_logdate` datetime DEFAULT NULL,
  `admin_lognum` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `admin_email_address` (`admin_email_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admin_files`
--

DROP TABLE IF EXISTS `admin_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_files` (
  `admin_files_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_files_name` varchar(64) NOT NULL DEFAULT '',
  `admin_files_is_boxes` tinyint(5) NOT NULL DEFAULT '0',
  `admin_files_to_boxes` int(11) NOT NULL DEFAULT '0',
  `admin_groups_id` set('1','19','20','21','22','23','24','25','26') NOT NULL DEFAULT '1',
  PRIMARY KEY (`admin_files_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admin_groups`
--

DROP TABLE IF EXISTS `admin_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_groups` (
  `admin_groups_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_groups_name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`admin_groups_id`),
  UNIQUE KEY `admin_groups_name` (`admin_groups_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admin_sessions`
--

DROP TABLE IF EXISTS `admin_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_sessions` (
  `sesskey` varchar(32) NOT NULL DEFAULT '',
  `expiry` int(11) unsigned NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`sesskey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alltime_gift`
--

DROP TABLE IF EXISTS `alltime_gift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alltime_gift` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `is_get` tinyint(1) NOT NULL DEFAULT '0',
  `query_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arena_record`
--

DROP TABLE IF EXISTS `arena_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arena_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `user_name` varchar(100) NOT NULL DEFAULT '',
  `user_avatar` int(10) NOT NULL DEFAULT '0',
  `user_level` int(10) NOT NULL DEFAULT '0',
  `user_robot` tinyint(1) NOT NULL DEFAULT '0',
  `oppo_id` bigint(20) NOT NULL DEFAULT '0',
  `oppo_name` varchar(100) NOT NULL DEFAULT '',
  `oppo_avatar` int(10) NOT NULL DEFAULT '0',
  `oppo_level` int(10) NOT NULL DEFAULT '0',
  `oppo_robot` tinyint(1) NOT NULL DEFAULT '0',
  `bt_result` int(5) NOT NULL DEFAULT '1',
  `bt_time` int(11) NOT NULL DEFAULT '0',
  `up_rank` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `oppo_id` (`oppo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auto_run`
--

DROP TABLE IF EXISTS `auto_run`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auto_run` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `script_name` varchar(100) DEFAULT NULL,
  `statu` tinyint(3) DEFAULT '0',
  `run_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `script_name` (`script_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client_patch_log`
--

DROP TABLE IF EXISTS `client_patch_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client_patch_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) DEFAULT '0',
  `filename` varchar(260) NOT NULL DEFAULT '',
  `hash` varchar(40) NOT NULL,
  `update_time` datetime NOT NULL,
  `svn_version` bigint(20) DEFAULT NULL,
  `active` int(10) DEFAULT '0',
  `binary_version` bigint(20) DEFAULT '0',
  `raw_filename` varchar(260) NOT NULL DEFAULT '',
  `size` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `filename` (`filename`(255)),
  KEY `active` (`active`),
  KEY `version` (`version`),
  KEY `binary_version` (`binary_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client_patch_log_temp`
--

DROP TABLE IF EXISTS `client_patch_log_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client_patch_log_temp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) DEFAULT '0',
  `filename` varchar(260) NOT NULL DEFAULT '',
  `hash` varchar(40) NOT NULL,
  `update_time` datetime NOT NULL,
  `svn_version` bigint(20) DEFAULT NULL,
  `active` int(10) DEFAULT '0',
  `binary_version` bigint(20) DEFAULT '0',
  `raw_filename` varchar(260) NOT NULL DEFAULT '',
  `size` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `filename` (`filename`(255)),
  KEY `active` (`active`),
  KEY `version` (`version`),
  KEY `binary_version` (`binary_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `continu_pay`
--

DROP TABLE IF EXISTS `continu_pay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `continu_pay` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `version` int(12) NOT NULL,
  `date` int(12) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cumulativeIntegral`
--

DROP TABLE IF EXISTS `cumulativeIntegral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cumulativeIntegral` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `createtime` int(11) DEFAULT NULL,
  `updatetime` int(11) DEFAULT NULL,
  `during_time` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cumulative_recharge`
--

DROP TABLE IF EXISTS `cumulative_recharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cumulative_recharge` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(20) NOT NULL COMMENT 'ç”¨æˆ·id',
  `gem` int(25) NOT NULL COMMENT 'å……å€¼é’»çŸ³',
  `updateTime` datetime NOT NULL COMMENT 'æ›´æ–°æ—¶é—´',
  `status` varchar(100) NOT NULL COMMENT 'é¢†å–çŠ¶æ€',
  `number` varchar(100) NOT NULL COMMENT 'é¢†å–æ¬¡æ•°',
  `version` int(10) NOT NULL COMMENT 'ç‰ˆæœ¬',
  UNIQUE KEY `id` (`id`),
  KEY `index_name` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_task_detail`
--

DROP TABLE IF EXISTS `daily_task_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_task_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `server_id` int(10) NOT NULL DEFAULT '0',
  `task` varchar(50) NOT NULL DEFAULT '',
  `last_refresh_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  KEY `task` (`task`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_task_server`
--

DROP TABLE IF EXISTS `daily_task_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_task_server` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `server_id` int(10) NOT NULL DEFAULT '0',
  `task` varchar(50) NOT NULL DEFAULT '',
  `last_run_time` int(11) NOT NULL DEFAULT '0',
  `lock` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  KEY `task` (`task`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device_id`
--

DROP TABLE IF EXISTS `device_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_id` (
  `device_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varbinary(16) NOT NULL,
  `uin` bigint(20) NOT NULL DEFAULT '0',
  `reg_ip` varchar(32) NOT NULL,
  `last_login_ip` varchar(32) NOT NULL,
  `link_num` int(10) NOT NULL,
  `platform_id` int(4) NOT NULL,
  PRIMARY KEY (`device_id`),
  KEY `uin` (`uin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `global`
--

DROP TABLE IF EXISTS `global`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `global` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` int(11) NOT NULL,
  `day` int(10) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key_day` (`key`,`day`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_info`
--

DROP TABLE IF EXISTS `guild_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guild_name` varchar(250) NOT NULL,
  `host_id` bigint(20) NOT NULL DEFAULT '0',
  `host_name` varchar(250) NOT NULL,
  `level` int(8) NOT NULL DEFAULT '1',
  `exp` int(8) NOT NULL DEFAULT '0',
  `resource` int(10) NOT NULL DEFAULT '0',
  `message` varchar(250) NOT NULL,
  `intro` varchar(250) NOT NULL,
  `funds` int(11) NOT NULL DEFAULT '0',
  `max_funds` int(11) NOT NULL DEFAULT '0',
  `server_id` int(11) NOT NULL DEFAULT '0',
  `activity` int(11) NOT NULL DEFAULT '0',
  `disband_time` int(10) NOT NULL,
  `gift_level` int(4) NOT NULL DEFAULT '0',
  `gift_exp` int(10) NOT NULL DEFAULT '0',
  `state` int(4) NOT NULL DEFAULT '1',
  `can_jump` int(4) NOT NULL DEFAULT '0',
  `user_number` int(11) NOT NULL,
  `avatar` int(4) NOT NULL,
  `avatar_frame` int(4) NOT NULL DEFAULT '1',
  `join_type` int(4) NOT NULL DEFAULT '1',
  `min_level_limit` int(4) NOT NULL,
  `vitality` int(10) NOT NULL,
  `distribute_time` int(11) NOT NULL,
  `distribute_num` int(4) NOT NULL,
  `drop_give_time` int(11) NOT NULL,
  `drop_give_count` int(4) NOT NULL,
  `drop_give_item` int(11) NOT NULL,
  `drop_give_user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_stage`
--

DROP TABLE IF EXISTS `guild_stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_stage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `guild_id` bigint(20) NOT NULL,
  `raid_id` int(10) NOT NULL DEFAULT '0',
  `stage_id` int(10) NOT NULL DEFAULT '0',
  `wave_index` tinyint(2) NOT NULL DEFAULT '0',
  `begin_time` int(11) NOT NULL,
  `challenger` bigint(20) NOT NULL DEFAULT '0',
  `challenger_begin_time` int(11) NOT NULL,
  `challenger_status` tinyint(2) NOT NULL,
  `detail` text NOT NULL,
  `progress` int(11) NOT NULL,
  `stage_progress` int(11) NOT NULL,
  `first_pass_timestamp` int(11) NOT NULL,
  `fast_pass_time` int(11) NOT NULL,
  `loot` text NOT NULL,
  `special_loot` text NOT NULL,
  `special_get` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `guild_id, raid_id` (`guild_id`,`raid_id`) USING BTREE,
  KEY `challenger` (`challenger`),
  KEY `stage_id` (`stage_id`),
  KEY `raid_id` (`raid_id`),
  KEY `server_id` (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_stage_battle_history`
--

DROP TABLE IF EXISTS `guild_stage_battle_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_stage_battle_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `user_name` varchar(30) NOT NULL DEFAULT '',
  `damage` int(11) NOT NULL DEFAULT '0',
  `battle_time` int(11) NOT NULL DEFAULT '0',
  `raid_id` int(10) NOT NULL,
  `stage_id` int(10) NOT NULL,
  `wave` tinyint(2) NOT NULL,
  `guild_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL,
  `is_kill` tinyint(2) NOT NULL,
  `heros` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `raid_id` (`raid_id`) USING BTREE,
  KEY `stage_id` (`stage_id`),
  KEY `guild_id` (`guild_id`),
  KEY `server_id` (`server_id`),
  KEY `is_kill` (`is_kill`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_stage_drop`
--

DROP TABLE IF EXISTS `guild_stage_drop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_stage_drop` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guild_id` bigint(20) NOT NULL DEFAULT '0',
  `raid_id` int(10) NOT NULL DEFAULT '0',
  `item_id` int(10) NOT NULL DEFAULT '0',
  `drop_count` tinyint(2) NOT NULL DEFAULT '0',
  `drop_user_id` bigint(20) NOT NULL DEFAULT '0',
  `drop_time` int(11) NOT NULL DEFAULT '0',
  `distribute_count` tinyint(2) NOT NULL DEFAULT '0',
  `min_distribute_time` int(11) NOT NULL,
  `state` tinyint(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `raid_id` (`raid_id`),
  KEY `item_id` (`item_id`),
  KEY `drop_user_id` (`drop_user_id`),
  KEY `guild_id` (`guild_id`) USING BTREE,
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_stage_items_history`
--

DROP TABLE IF EXISTS `guild_stage_items_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_stage_items_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `user_name` varchar(30) NOT NULL DEFAULT '',
  `item_id` int(10) NOT NULL DEFAULT '0',
  `sender_user_id` int(10) NOT NULL DEFAULT '0',
  `sender_user_name` varchar(30) NOT NULL DEFAULT '',
  `send_time` int(11) NOT NULL DEFAULT '0',
  `type` tinyint(2) NOT NULL DEFAULT '0',
  `raid_id` int(10) NOT NULL,
  `guild_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `sender_user_id` (`sender_user_id`),
  KEY `item_id` (`item_id`),
  KEY `type` (`type`),
  KEY `guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_vitality_rank`
--

DROP TABLE IF EXISTS `guild_vitality_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_vitality_rank` (
  `guild_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `vitality0` bigint(20) NOT NULL DEFAULT '0',
  `vitality1` bigint(20) NOT NULL DEFAULT '0',
  `vitality2` bigint(20) NOT NULL DEFAULT '0',
  `vitality3` bigint(20) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `query_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_rank` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guild_id`),
  KEY `rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `local_strings`
--

DROP TABLE IF EXISTS `local_strings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `local_strings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `key` varchar(255) DEFAULT NULL COMMENT 'string key',
  `lang` varchar(10) DEFAULT NULL COMMENT 'language id',
  `string` text COMMENT 'local string',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lotto_activity`
--

DROP TABLE IF EXISTS `lotto_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lotto_activity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `current_step` tinyint(1) NOT NULL DEFAULT '0',
  `star_time` int(10) NOT NULL,
  `query_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news_list`
--

DROP TABLE IF EXISTS `news_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `pubdate` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `image_path` varchar(100) DEFAULT NULL,
  `category` varchar(20) DEFAULT NULL,
  `digest` varchar(600) DEFAULT NULL,
  `content` text,
  `seed` varchar(600) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pay_game`
--

DROP TABLE IF EXISTS `pay_game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pay_game` (
  `pay_game_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pay_id` bigint(20) NOT NULL DEFAULT '0',
  `user_id` varchar(32) NOT NULL DEFAULT '',
  `pay_type` tinyint(1) NOT NULL DEFAULT '0',
  `transaction_type` tinyint(1) NOT NULL DEFAULT '1',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `pay_money` double(8,2) NOT NULL DEFAULT '0.00',
  `gold_num` int(8) NOT NULL DEFAULT '0',
  `pay_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `remark` text,
  `server_unique_flag` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `try_nums` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pay_game_id`),
  KEY `pay_id` (`pay_id`),
  KEY `user_id` (`user_id`),
  KEY `pay_type` (`pay_type`),
  KEY `state` (`state`),
  KEY `pay_date` (`pay_date`),
  KEY `transaction_type` (`transaction_type`),
  KEY `pay_money` (`pay_money`),
  KEY `gold_num` (`gold_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pay_info`
--

DROP TABLE IF EXISTS `pay_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pay_info` (
  `pay_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `buyer_id` varchar(32) NOT NULL DEFAULT '',
  `receiver_id` varchar(32) NOT NULL DEFAULT '',
  `pay_type` tinyint(1) NOT NULL DEFAULT '0',
  `order_id` varchar(32) NOT NULL DEFAULT '',
  `transaction_id` varchar(50) NOT NULL DEFAULT '',
  `order_state` tinyint(2) NOT NULL DEFAULT '0',
  `pay_money` double(8,2) NOT NULL DEFAULT '0.00',
  `order_money` double(8,2) NOT NULL DEFAULT '0.00',
  `gold_num` int(8) NOT NULL DEFAULT '0',
  `order_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `pay_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `remark` text,
  `order_ip` varchar(15) NOT NULL DEFAULT '',
  `country` varchar(10) NOT NULL DEFAULT '',
  `transaction_type` int(10) NOT NULL DEFAULT '1',
  `paypal_preapprovalkey` varchar(32) NOT NULL DEFAULT '',
  `paypal_paykey` varchar(32) NOT NULL DEFAULT '',
  `paypal_email` varchar(64) NOT NULL DEFAULT '',
  `paypal_date` varchar(32) NOT NULL DEFAULT '',
  `server_unique_flag` varchar(50) NOT NULL,
  `check_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `paypal_fee` double(8,2) NOT NULL DEFAULT '0.00',
  `order_time` int(11) NOT NULL,
  `pay_time` int(11) NOT NULL,
  `game_center_id` varchar(80) NOT NULL,
  `level` int(10) NOT NULL,
  `vip_level` int(3) NOT NULL,
  `is_first` int(3) NOT NULL,
  `device_id` varchar(50) NOT NULL,
  PRIMARY KEY (`pay_id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `receiver_id` (`receiver_id`),
  KEY `order_id` (`order_id`),
  KEY `order_state` (`order_state`),
  KEY `pay_type` (`pay_type`),
  KEY `order_date` (`order_date`),
  KEY `pay_date` (`pay_date`),
  KEY `transaction_type` (`transaction_type`),
  KEY `transaction_id` (`transaction_id`),
  KEY `pay_money` (`pay_money`),
  KEY `order_money` (`order_money`),
  KEY `check_date` (`check_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phpErrorLog`
--

DROP TABLE IF EXISTS `phpErrorLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phpErrorLog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `category` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `logtime` int(11) DEFAULT NULL,
  `message` text COLLATE utf8_bin,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phperrorlog`
--

DROP TABLE IF EXISTS `phperrorlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phperrorlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` varchar(128) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `logtime` int(11) DEFAULT NULL,
  `message` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player` (
  `user_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `nickname` varchar(250) NOT NULL DEFAULT '',
  `last_set_name_time` int(11) NOT NULL DEFAULT '0',
  `avatar` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `exp` bigint(20) NOT NULL DEFAULT '0',
  `money` bigint(20) NOT NULL DEFAULT '0',
  `gem` bigint(20) NOT NULL DEFAULT '0',
  `arena_point` int(11) NOT NULL DEFAULT '0',
  `crusade_point` int(11) NOT NULL DEFAULT '0',
  `guild_point` int(11) NOT NULL,
  `last_midas_time` int(11) NOT NULL DEFAULT '0',
  `today_midas_times` int(11) NOT NULL DEFAULT '0',
  `total_online_time` int(11) NOT NULL,
  `tutorialstep` int(5) DEFAULT NULL,
  `rechargegem` bigint(20) NOT NULL,
  `facebook_follow` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `server_id` (`server_id`),
  KEY `name` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_act_stage`
--

DROP TABLE IF EXISTS `player_act_stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_act_stage` (
  `user_id` bigint(20) NOT NULL,
  `last_reset_time` int(11) NOT NULL DEFAULT '0' COMMENT 'last daliy record reset time',
  `daily_record` text NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_activity`
--

DROP TABLE IF EXISTS `player_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_activity` (
  `user_id` bigint(20) NOT NULL,
  `time_zone` int(11) NOT NULL DEFAULT '1',
  `last_login_reward_time` int(11) NOT NULL DEFAULT '0',
  `cost_gem` bigint(11) NOT NULL DEFAULT '0' COMMENT 'total num',
  `last_cost_gem_time` int(11) NOT NULL DEFAULT '0' COMMENT 'last cost time',
  PRIMARY KEY (`user_id`),
  KEY `time_zone` (`time_zone`),
  KEY `cost_gem` (`cost_gem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_arena`
--

DROP TABLE IF EXISTS `player_arena`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_arena` (
  `user_id` bigint(20) NOT NULL,
  `zone_id` int(11) NOT NULL DEFAULT '1',
  `server_id` int(11) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `best_rank` int(10) NOT NULL DEFAULT '0',
  `reward_rank_list` varchar(255) NOT NULL DEFAULT '',
  `fight_count` int(10) NOT NULL DEFAULT '0',
  `last_fight_time` int(11) NOT NULL DEFAULT '0',
  `buy_count` int(11) NOT NULL DEFAULT '0',
  `last_buy_time` int(11) NOT NULL DEFAULT '0',
  `win_count` int(10) NOT NULL DEFAULT '0',
  `lineup` varchar(250) NOT NULL DEFAULT '',
  `all_gs` int(11) NOT NULL DEFAULT '0',
  `is_robot` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `server_id` (`server_id`),
  KEY `zone_id` (`zone_id`),
  KEY `all_gs` (`all_gs`),
  KEY `rank` (`rank`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_arena_fixed`
--

DROP TABLE IF EXISTS `player_arena_fixed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_arena_fixed` (
  `user_id` bigint(20) NOT NULL,
  `zone_id` int(11) NOT NULL DEFAULT '1',
  `server_id` int(11) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `best_rank` int(10) NOT NULL DEFAULT '0',
  `reward_rank_list` varchar(255) NOT NULL DEFAULT '',
  `fight_count` int(10) NOT NULL DEFAULT '0',
  `last_fight_time` int(11) NOT NULL DEFAULT '0',
  `buy_count` int(11) NOT NULL DEFAULT '0',
  `last_buy_time` int(11) NOT NULL DEFAULT '0',
  `win_count` int(10) NOT NULL DEFAULT '0',
  `lineup` varchar(250) NOT NULL DEFAULT '',
  `all_gs` int(11) NOT NULL DEFAULT '0',
  `is_robot` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `server_id` (`server_id`),
  KEY `zone_id` (`zone_id`),
  KEY `all_gs` (`all_gs`),
  KEY `rank` (`rank`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_battle`
--

DROP TABLE IF EXISTS `player_battle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_battle` (
  `user_id` bigint(20) NOT NULL,
  `enter_stage_time` int(11) NOT NULL DEFAULT '0',
  `stage_group` int(11) NOT NULL DEFAULT '0',
  `stage_id` int(11) NOT NULL DEFAULT '0',
  `srand` int(11) NOT NULL DEFAULT '0',
  `loot` text NOT NULL,
  `pvp_buffer` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_chat`
--

DROP TABLE IF EXISTS `player_chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_chat` (
  `user_id` bigint(20) NOT NULL,
  `world_chat_times` int(11) NOT NULL DEFAULT '0',
  `last_reset_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_connection_info`
--

DROP TABLE IF EXISTS `player_connection_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_connection_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `account` varchar(250) NOT NULL DEFAULT '1',
  `proxy_id` varchar(100) NOT NULL,
  `socket_id` varchar(100) NOT NULL,
  `type` int(11) NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `address` varchar(250) NOT NULL DEFAULT '0.0.0.0:0',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ukey` (`proxy_id`,`socket_id`,`type`),
  KEY `key` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_daily_login`
--

DROP TABLE IF EXISTS `player_daily_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_daily_login` (
  `user_id` bigint(20) NOT NULL,
  `today_claim_status` int(11) NOT NULL DEFAULT '0',
  `cur_month_claim_times` int(11) NOT NULL DEFAULT '0',
  `last_claim_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_elite_stage`
--

DROP TABLE IF EXISTS `player_elite_stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_elite_stage` (
  `user_id` bigint(20) NOT NULL,
  `max_stage_id` int(11) NOT NULL DEFAULT '0',
  `stage_stars` text NOT NULL,
  `last_reset_time` int(11) NOT NULL DEFAULT '0' COMMENT 'last daliy record reset time',
  `daily_record` text NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_fighting_strength_rank`
--

DROP TABLE IF EXISTS `player_fighting_strength_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_fighting_strength_rank` (
  `user_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `gs` bigint(20) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `last_rank` int(10) NOT NULL DEFAULT '0',
  `query_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_robot` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_fighting_strength_rank_limit`
--

DROP TABLE IF EXISTS `player_fighting_strength_rank_limit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_fighting_strength_rank_limit` (
  `user_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `gs` bigint(20) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `last_rank` int(10) NOT NULL DEFAULT '0',
  `query_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_robot` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_guild`
--

DROP TABLE IF EXISTS `player_guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_guild` (
  `user_id` bigint(20) NOT NULL,
  `guild_id` bigint(20) NOT NULL DEFAULT '0',
  `guild_position` int(8) NOT NULL DEFAULT '0',
  `last_quit_time` int(11) NOT NULL DEFAULT '0',
  `contribution` int(11) NOT NULL DEFAULT '0',
  `daily_contribution` int(11) NOT NULL DEFAULT '0',
  `total_contribution` int(11) NOT NULL,
  `last_refresh_daily_contribution_time` int(11) DEFAULT NULL,
  `last_guild_contribution` int(11) NOT NULL DEFAULT '0',
  `last_donation_time` int(11) DEFAULT NULL,
  `claim_time` int(11) NOT NULL,
  `claim_chest_time` int(11) NOT NULL,
  `claim_chest_num` int(10) NOT NULL,
  `last_guild_id` bigint(20) NOT NULL,
  `worship_last_time` int(11) NOT NULL,
  `worship_number` int(11) NOT NULL,
  `worship_uid` varchar(255) NOT NULL,
  `worship_reward_number` int(11) NOT NULL,
  `worship_reward_last_time` int(11) NOT NULL,
  `worship_reward_claim_time` int(11) NOT NULL,
  `worship_reward_info` varchar(255) NOT NULL,
  `vitality` int(11) NOT NULL,
  `vitality_time` int(11) NOT NULL,
  `join_time` int(11) NOT NULL,
  `stage_max_damage` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `guild_id` (`guild_id`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_guild_app_queue`
--

DROP TABLE IF EXISTS `player_guild_app_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_guild_app_queue` (
  `user_id` bigint(20) NOT NULL,
  `raid_id` int(10) NOT NULL,
  `item_id` int(11) NOT NULL DEFAULT '0',
  `guild_id` bigint(20) NOT NULL DEFAULT '0',
  `server_id` int(11) NOT NULL DEFAULT '0',
  `apply_time` int(11) NOT NULL DEFAULT '0',
  `jump_times` int(10) NOT NULL DEFAULT '0',
  `cost_money` int(10) NOT NULL DEFAULT '0',
  `sort` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `server_id` (`server_id`),
  KEY `item_id` (`item_id`),
  KEY `guild_id` (`guild_id`),
  KEY `raid_id` (`raid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_guild_apply_info`
--

DROP TABLE IF EXISTS `player_guild_apply_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_guild_apply_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `guild_id` bigint(20) NOT NULL,
  `apply_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ugid` (`user_id`,`guild_id`) USING BTREE,
  KEY `gid` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_guild_stage`
--

DROP TABLE IF EXISTS `player_guild_stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_guild_stage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `raid_id` int(10) NOT NULL DEFAULT '0',
  `stage_id` int(10) NOT NULL DEFAULT '0',
  `wave_index` tinyint(2) NOT NULL DEFAULT '0',
  `battle_time` int(11) NOT NULL DEFAULT '0',
  `count` tinyint(2) NOT NULL DEFAULT '0',
  `total_damage` int(11) NOT NULL,
  `server_id` int(11) NOT NULL,
  `guild_id` bigint(20) NOT NULL,
  `max_damage` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id, raid_id` (`user_id`,`raid_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_hero`
--

DROP TABLE IF EXISTS `player_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_hero` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `tid` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `exp` bigint(20) NOT NULL DEFAULT '0',
  `rank` int(11) NOT NULL DEFAULT '1',
  `stars` int(11) NOT NULL DEFAULT '1',
  `gs` bigint(20) NOT NULL DEFAULT '0',
  `state` int(11) NOT NULL DEFAULT '0',
  `skill1_level` int(10) NOT NULL DEFAULT '1',
  `skill2_level` int(10) NOT NULL DEFAULT '1',
  `skill3_level` int(10) NOT NULL DEFAULT '21',
  `skill4_level` int(10) NOT NULL DEFAULT '41',
  `hero_equip` varchar(255) NOT NULL DEFAULT '0-0|0-0|0-0|0-0|0-0|0-0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `tid` (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_hire_hero`
--

DROP TABLE IF EXISTS `player_hire_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_hire_hero` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `guild_id` bigint(20) NOT NULL,
  `hire_time` int(11) NOT NULL DEFAULT '0',
  `hire_user_id` bigint(20) NOT NULL,
  `hire_hero_tid` bigint(20) NOT NULL,
  `hire_from` int(4) NOT NULL,
  `is_use` tinyint(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `guild_id` (`guild_id`),
  KEY `hire_hero_id` (`hire_user_id`,`hire_hero_tid`),
  KEY `hire_from` (`hire_from`),
  KEY `is_use` (`is_use`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_items`
--

DROP TABLE IF EXISTS `player_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `item_id` int(10) NOT NULL DEFAULT '0',
  `count` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_level_activity`
--

DROP TABLE IF EXISTS `player_level_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_level_activity` (
  `user_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `zone_id` int(11) NOT NULL DEFAULT '0',
  `state` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `zone_id` (`zone_id`),
  KEY `state` (`state`),
  KEY `server_id` (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_mail`
--

DROP TABLE IF EXISTS `player_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_mail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sid` bigint(20) DEFAULT '0',
  `user_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `title` text NOT NULL,
  `from` text NOT NULL,
  `content` text NOT NULL,
  `mail_cfg_id` int(11) NOT NULL DEFAULT '0',
  `mail_params` text NOT NULL,
  `mail_time` int(11) NOT NULL DEFAULT '0',
  `expire_time` int(11) NOT NULL DEFAULT '0',
  `money` int(11) NOT NULL DEFAULT '0',
  `diamonds` int(11) NOT NULL DEFAULT '0',
  `items` text NOT NULL,
  `points` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `template` int(11) NOT NULL,
  `server_id` int(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `template` (`template`),
  KEY `server_id` (`server_id`),
  KEY `idx_user_id_expire_time` (`user_id`,`expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_month_card`
--

DROP TABLE IF EXISTS `player_month_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_month_card` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `start_time` int(11) NOT NULL DEFAULT '0',
  `end_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `update_num` int(11) NOT NULL DEFAULT '0',
  `transaction_type` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `transaction_type` (`transaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_normal_stage`
--

DROP TABLE IF EXISTS `player_normal_stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_normal_stage` (
  `user_id` bigint(20) NOT NULL,
  `max_stage_id` int(11) NOT NULL DEFAULT '0',
  `stage_stars` text NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_notify`
--

DROP TABLE IF EXISTS `player_notify`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_notify` (
  `user_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_provide_hero`
--

DROP TABLE IF EXISTS `player_provide_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_provide_hero` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `guild_id` bigint(20) NOT NULL,
  `provide_time` int(11) NOT NULL DEFAULT '0',
  `hero_tid` bigint(20) NOT NULL,
  `hire_income` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `guild_id` (`guild_id`),
  KEY `user_id` (`user_id`,`hero_tid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_shop`
--

DROP TABLE IF EXISTS `player_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_shop` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `shop_tid` int(11) NOT NULL DEFAULT '0',
  `last_auto_refresh_time` int(11) NOT NULL DEFAULT '0',
  `expire_time` int(11) NOT NULL DEFAULT '0',
  `last_manual_refresh_time` int(11) NOT NULL DEFAULT '0',
  `today_times` int(11) NOT NULL DEFAULT '0',
  `cur_goods` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `tid` (`shop_tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_skill`
--

DROP TABLE IF EXISTS `player_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_skill` (
  `user_id` bigint(20) NOT NULL,
  `point` int(11) NOT NULL DEFAULT '0',
  `last_add_time` int(11) NOT NULL DEFAULT '0',
  `buy_times` int(11) NOT NULL DEFAULT '0',
  `last_buy_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_stars_rank`
--

DROP TABLE IF EXISTS `player_stars_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_stars_rank` (
  `user_id` bigint(20) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `stars` bigint(20) NOT NULL DEFAULT '0',
  `rank` int(10) NOT NULL DEFAULT '0',
  `last_rank` int(10) NOT NULL DEFAULT '0',
  `query_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_robot` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_task`
--

DROP TABLE IF EXISTS `player_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `task_line` int(11) NOT NULL DEFAULT '0',
  `task_id` int(11) NOT NULL DEFAULT '0',
  `task_status` tinyint(1) NOT NULL DEFAULT '1',
  `task_target` int(11) NOT NULL DEFAULT '0',
  `claim_reward_time` int(11) NOT NULL DEFAULT '0',
  `last_reset_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_tavern`
--

DROP TABLE IF EXISTS `player_tavern`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_tavern` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `box_type` int(11) NOT NULL DEFAULT '0',
  `left_count` int(11) NOT NULL DEFAULT '0',
  `last_claim_time` int(11) NOT NULL DEFAULT '0',
  `first_draw` int(11) NOT NULL DEFAULT '0',
  `free_claim_time` int(11) NOT NULL,
  `pay_num` int(11) NOT NULL,
  `fate_id` int(11) NOT NULL,
  `fate` int(11) NOT NULL,
  `double_rate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_tbc`
--

DROP TABLE IF EXISTS `player_tbc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_tbc` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `cur_stage` int(11) NOT NULL DEFAULT '1',
  `reset_times` int(11) NOT NULL DEFAULT '0',
  `self_heros` text NOT NULL,
  `stages` text NOT NULL,
  `oppo_heros` text,
  `hire_heros` text NOT NULL,
  `battle_heros` text,
  `rand_seed` int(11) DEFAULT NULL,
  `last_reset_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_tutorial`
--

DROP TABLE IF EXISTS `player_tutorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_tutorial` (
  `user_id` bigint(20) NOT NULL,
  `count` int(10) NOT NULL DEFAULT '90',
  `tutorial` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_vip`
--

DROP TABLE IF EXISTS `player_vip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_vip` (
  `user_id` bigint(20) NOT NULL,
  `vip` int(11) NOT NULL DEFAULT '0',
  `recharge` int(11) NOT NULL DEFAULT '0',
  `recharge_limit` varchar(255) NOT NULL DEFAULT '',
  `first_pay_reward` tinyint(2) NOT NULL,
  `activity_day` int(11) NOT NULL DEFAULT '0',
  `activity_desc` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player_vitality`
--

DROP TABLE IF EXISTS `player_vitality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_vitality` (
  `user_id` bigint(20) NOT NULL,
  `cur_vitality` int(11) NOT NULL DEFAULT '0',
  `last_change_time` int(11) NOT NULL DEFAULT '0',
  `today_buy` int(11) NOT NULL DEFAULT '0',
  `last_buy_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_id_map`
--

DROP TABLE IF EXISTS `product_id_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_id_map` (
  `product_id` int(10) NOT NULL COMMENT 'ID in Recharge.lua',
  `ios_product_id` int(10) NOT NULL DEFAULT '0' COMMENT 'Product ID seted in Apple Store',
  `android_product_id` int(10) NOT NULL DEFAULT '0' COMMENT 'Product ID seted in Google Play Store',
  `add_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`product_id`),
  KEY `ios_product_id` (`ios_product_id`),
  KEY `android_product_id` (`android_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxy_info`
--

DROP TABLE IF EXISTS `proxy_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proxy_info` (
  `proxy_id` varchar(250) NOT NULL,
  `address` varchar(80) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `onlinenum` int(11) NOT NULL DEFAULT '0',
  `last_update_time` bigint(20) NOT NULL DEFAULT '0',
  `last_report_time` bigint(20) NOT NULL DEFAULT '0',
  `last_report_status` int(11) NOT NULL,
  PRIMARY KEY (`proxy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recharge_rebate_info`
--

DROP TABLE IF EXISTS `recharge_rebate_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recharge_rebate_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `get_count` tinyint(1) NOT NULL DEFAULT '0',
  `star_time` int(10) NOT NULL,
  `query_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `server_list`
--

DROP TABLE IF EXISTS `server_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server_list` (
  `server_id` int(11) NOT NULL AUTO_INCREMENT,
  `server_name` varchar(50) NOT NULL DEFAULT '',
  `server_state` int(1) NOT NULL DEFAULT '1',
  `server_start_date` int(11) NOT NULL,
  `server_zone_flag` varchar(100) NOT NULL,
  `new_server_id` varchar(255) NOT NULL DEFAULT '-1',
  `new_server_time` int(11) NOT NULL DEFAULT '0',
  `server_config` varchar(50) NOT NULL DEFAULT '0',
  `server_rule` text NOT NULL,
  `server_channel` varchar(20) DEFAULT NULL,
  `server_key` varchar(32) DEFAULT NULL,
  `server_ip` varchar(20) DEFAULT NULL,
  `server_host` varchar(20) DEFAULT NULL,
  `server_reamrk` text NOT NULL,
  `server_alias` varchar(50) NOT NULL DEFAULT '',
  `game_id` int(8) NOT NULL DEFAULT '0',
  `beta_flag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`server_id`),
  KEY `game_id` (`game_id`),
  KEY `server_state` (`server_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `server_name_pool`
--

DROP TABLE IF EXISTS `server_name_pool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server_name_pool` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `server_name` varchar(50) NOT NULL DEFAULT '' COMMENT 'æœåŠ¡å™¨åç§°',
  `server_name_zh` varchar(50) NOT NULL COMMENT 'æœåŠ¡å™¨ä¸­æ–‡åç§°',
  `sort` int(5) NOT NULL COMMENT 'æŽ’åº, ä¼˜å…ˆå–å°çš„',
  `is_used` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'æ˜¯å¦å·²ç»è¢«ä½¿ç”¨',
  `use_time` int(10) NOT NULL DEFAULT '0' COMMENT 'ä½¿ç”¨æ—¶é—´',
  `state` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'æ˜¯å¦å¯ç”¨',
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_name` (`server_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='æœåŠ¡å™¨åç§°å¤‡é€‰è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `template_mail`
--

DROP TABLE IF EXISTS `template_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template_mail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) DEFAULT '0',
  `description` varchar(200) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_list`
--

DROP TABLE IF EXISTS `time_zone_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_zone_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_zone` varchar(50) NOT NULL DEFAULT 'Asia/Shanghai',
  PRIMARY KEY (`id`),
  KEY `time_zone` (`time_zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `uin` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `game_center_id` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(64) NOT NULL,
  `password` varchar(32) NOT NULL,
  `email_state` tinyint(1) NOT NULL DEFAULT '0',
  `reg_ip` varchar(32) NOT NULL,
  `last_login_ip` varchar(32) NOT NULL,
  `user_zone_id` int(10) NOT NULL DEFAULT '1',
  `user_zone` varchar(50) NOT NULL DEFAULT 'Asia/Shanghai',
  `reg_time` datetime NOT NULL,
  `last_login_time` datetime NOT NULL,
  `reg_time_stamp` int(11) NOT NULL DEFAULT '0',
  `last_login_time_stamp` int(11) NOT NULL DEFAULT '0',
  `login_nums` int(11) NOT NULL DEFAULT '0',
  `country` varchar(100) NOT NULL,
  `STATUS` tinyint(1) NOT NULL,
  `fbuid` bigint(32) unsigned NOT NULL DEFAULT '0',
  `fb_email` varchar(64) NOT NULL,
  `is_robot` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_master` tinyint(1) unsigned DEFAULT NULL,
  `parent` bigint(20) DEFAULT NULL,
  `ticket` int(4) DEFAULT NULL,
  `secondary_email` varchar(64) DEFAULT NULL,
  `session_key` varchar(16) NOT NULL,
  `platform` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1: iphone, 2:ipad, 3:android',
  `language` varchar(50) NOT NULL,
  `model` varchar(100) NOT NULL,
  `OSVer` varchar(70) NOT NULL,
  PRIMARY KEY (`uin`),
  KEY `email` (`email`),
  KEY `reg_ip` (`reg_ip`),
  KEY `last_login_ip` (`last_login_ip`),
  KEY `first_login_time` (`reg_time`),
  KEY `last_login_time` (`last_login_time`),
  KEY `login_nums` (`login_nums`),
  KEY `email_state` (`email_state`),
  KEY `device_id` (`game_center_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_server`
--

DROP TABLE IF EXISTS `user_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_server` (
  `user_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uin` bigint(20) unsigned NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT '0',
  `reg_ip` varchar(32) NOT NULL DEFAULT '',
  `last_login_ip` varchar(32) NOT NULL DEFAULT '',
  `reg_time` int(11) NOT NULL DEFAULT '0',
  `last_login_time` int(11) NOT NULL DEFAULT '0',
  `login_nums` int(11) NOT NULL DEFAULT '0',
  `new_server_id` varchar(255) NOT NULL DEFAULT '-1',
  `new_server_time` int(11) NOT NULL DEFAULT '0',
  `STATUS` tinyint(1) NOT NULL DEFAULT '0',
  `sid` bigint(20) unsigned DEFAULT NULL,
  `parent` bigint(20) DEFAULT NULL,
  `ticket` varchar(255) DEFAULT NULL,
  `zone_flag` varchar(100) DEFAULT NULL,
  `platform` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1: iphone, 2:ipad, 3:android',
  PRIMARY KEY (`user_id`),
  KEY `uin` (`uin`),
  KEY `server_flag` (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_settings` (
  `uin` bigint(20) NOT NULL,
  `settings` text,
  PRIMARY KEY (`uin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-10 15:55:44
