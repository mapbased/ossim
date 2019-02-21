-- MySQL Script generated by MySQL Workbench
-- Tue May 26 12:56:29 2015
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema alienvault_siem
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `device`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `device` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `device_ip` VARBINARY(16) NULL DEFAULT NULL,
  `interface` TEXT NULL DEFAULT NULL,
  `sensor_id` BINARY(16) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `sensor_ip` (`sensor_id` ASC),
  INDEX `ip` (`device_ip` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `extra_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `extra_data` (
  `event_id` BINARY(16) NOT NULL,
  `filename` VARCHAR(256) NULL DEFAULT NULL,
  `username` VARCHAR(64) NULL DEFAULT NULL,
  `password` VARCHAR(64) NULL DEFAULT NULL,
  `userdata1` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata2` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata3` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata4` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata5` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata6` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata7` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata8` VARCHAR(1024) NULL DEFAULT NULL,
  `userdata9` VARCHAR(1024) NULL DEFAULT NULL,
  `data_payload` TEXT NULL DEFAULT NULL,
  `binary_data` BLOB NULL DEFAULT NULL,
  PRIMARY KEY (`event_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `po_acid_event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `po_acid_event` (
  `ctx` BINARY(16) NOT NULL,
  `device_id` INT UNSIGNED NOT NULL,
  `plugin_id` INT UNSIGNED NOT NULL,
  `plugin_sid` INT UNSIGNED NOT NULL,
  `ip_src` VARBINARY(16) NOT NULL,
  `ip_dst` VARBINARY(16) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `src_host` BINARY(16) NOT NULL DEFAULT 0x0,
  `dst_host` BINARY(16) NOT NULL DEFAULT 0x0,
  `src_net` BINARY(16) NOT NULL DEFAULT 0x0,
  `dst_net` BINARY(16) NOT NULL DEFAULT 0x0,
  `cnt` INT UNSIGNED NOT NULL DEFAULT 0,
  INDEX `day` (`timestamp` ASC),
  INDEX `plugin_id` (`plugin_id` ASC, `plugin_sid` ASC),
  INDEX `src_host` (`src_host` ASC),
  INDEX `dst_host` (`dst_host` ASC),
  INDEX `src_net` (`src_net` ASC),
  INDEX `dst_net` (`dst_net` ASC),
  PRIMARY KEY (`ctx`, `device_id`, `plugin_id`, `plugin_sid`, `ip_src`, `ip_dst`, `timestamp`, `src_host`, `dst_host`, `src_net`, `dst_net`),
  INDEX `ip_src` (`ip_src` ASC),
  INDEX `ip_dst` (`ip_dst` ASC),
  INDEX `device_id` (`device_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ac_acid_event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ac_acid_event` (
  `ctx` BINARY(16) NOT NULL,
  `device_id` INT UNSIGNED NOT NULL,
  `plugin_id` INT UNSIGNED NOT NULL,
  `plugin_sid` INT UNSIGNED NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `src_host` BINARY(16) NOT NULL DEFAULT 0x0,
  `dst_host` BINARY(16) NOT NULL DEFAULT 0x0,
  `src_net` BINARY(16) NOT NULL DEFAULT 0x0,
  `dst_net` BINARY(16) NOT NULL DEFAULT 0x0,
  `cnt` INT UNSIGNED NOT NULL DEFAULT 0,
  INDEX `day` (`timestamp` ASC),
  INDEX `src_host` (`src_host` ASC),
  INDEX `dst_host` (`dst_host` ASC),
  INDEX `plugin_id` (`plugin_id` ASC, `plugin_sid` ASC),
  PRIMARY KEY (`ctx`, `device_id`, `plugin_id`, `plugin_sid`, `timestamp`, `src_host`, `dst_host`, `src_net`, `dst_net`),
  INDEX `src_net` (`src_net` ASC),
  INDEX `dst_net` (`dst_net` ASC),
  INDEX `device_id` (`device_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `acid_event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `acid_event` (
  `id` BINARY(16) NOT NULL,
  `device_id` INT UNSIGNED NOT NULL,
  `ctx` BINARY(16) NOT NULL DEFAULT 0x0,
  `timestamp` DATETIME NOT NULL,
  `ip_src` VARBINARY(16) NULL DEFAULT NULL,
  `ip_dst` VARBINARY(16) NULL DEFAULT NULL,
  `ip_proto` INT NULL DEFAULT NULL,
  `layer4_sport` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `layer4_dport` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `ossim_priority` TINYINT NULL DEFAULT '1',
  `ossim_reliability` TINYINT NULL DEFAULT '1',
  `ossim_asset_src` TINYINT NULL DEFAULT '1',
  `ossim_asset_dst` TINYINT NULL DEFAULT '1',
  `ossim_risk_c` TINYINT NULL DEFAULT '1',
  `ossim_risk_a` TINYINT NULL DEFAULT '1',
  `plugin_id` INT UNSIGNED NULL DEFAULT NULL,
  `plugin_sid` INT UNSIGNED NULL DEFAULT NULL,
  `tzone` FLOAT NOT NULL DEFAULT '0',
  `ossim_correlation` TINYINT NULL DEFAULT '0',
  `src_hostname` VARCHAR(64) NULL DEFAULT NULL,
  `dst_hostname` VARCHAR(64) NULL DEFAULT NULL,
  `src_mac` BINARY(6) NULL DEFAULT NULL,
  `dst_mac` BINARY(6) NULL DEFAULT NULL,
  `src_host` BINARY(16) NULL DEFAULT NULL,
  `dst_host` BINARY(16) NULL DEFAULT NULL,
  `src_net` BINARY(16) NULL DEFAULT NULL,
  `dst_net` BINARY(16) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `timestamp` (`timestamp` ASC,`plugin_id`,`plugin_sid`),
  INDEX `layer4_dport` (`layer4_dport` ASC),
  INDEX `ip_src` (`ip_src` ASC),
  INDEX `ip_dst` (`ip_dst` ASC),
  INDEX `acid_event_ossim_risk_a` (`ossim_risk_a` ASC),
  INDEX `plugin` (`plugin_id` ASC, `plugin_sid` ASC),
  INDEX `src_host` (`src_host` ASC),
  INDEX `dst_host` (`dst_host` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `reputation_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reputation_data` (
  `event_id` BINARY(16) NOT NULL,
  `rep_ip_src` VARBINARY(16) NULL DEFAULT NULL,
  `rep_ip_dst` VARBINARY(16) NULL DEFAULT NULL,
  `rep_prio_src` TINYINT UNSIGNED NULL DEFAULT NULL,
  `rep_prio_dst` TINYINT UNSIGNED NULL DEFAULT NULL,
  `rep_rel_src` TINYINT UNSIGNED NULL DEFAULT NULL,
  `rep_rel_dst` TINYINT UNSIGNED NULL DEFAULT NULL,
  `rep_act_src` VARCHAR(64) NULL DEFAULT NULL,
  `rep_act_dst` VARCHAR(64) NULL DEFAULT NULL,
  PRIMARY KEY (`event_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `last_update`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `last_update` (
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `reference_system`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reference_system` (
  `ref_system_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ref_system_name` VARCHAR(20) NULL DEFAULT NULL,
  `icon` MEDIUMBLOB NOT NULL,
  `url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ref_system_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `reference`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reference` (
  `ref_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ref_system_id` INT(10) UNSIGNED NOT NULL,
  `ref_tag` TEXT NOT NULL,
  PRIMARY KEY (`ref_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `schema`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `schema` (
  `vseq` INT(10) UNSIGNED NOT NULL,
  `ctime` DATETIME NOT NULL,
  PRIMARY KEY (`vseq`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `sig_reference`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sig_reference` (
  `plugin_id` INT(11) NOT NULL,
  `plugin_sid` INT(11) NOT NULL,
  `ref_id` INT(10) UNSIGNED NOT NULL,
  `ctx` BINARY(16) NOT NULL,
  PRIMARY KEY (`plugin_id`, `plugin_sid`, `ref_id`, `ctx`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `idm_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `idm_data` (
  `event_id` BINARY(16) NOT NULL,
  `username` VARCHAR(64) NULL DEFAULT NULL,
  `domain` VARCHAR(64) NULL DEFAULT NULL,
  `from_src` TINYINT(1) NULL DEFAULT NULL,
  INDEX `event_id` (`event_id` ASC),
  INDEX `usrdmn` (`username` ASC, `domain` ASC),
  INDEX `domain` (`domain` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `otx_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otx_data` (
  `event_id` BINARY(16) NOT NULL,
  `pulse_id` VARBINARY(16) NOT NULL,
  `ioc_hash` VARCHAR(32) NOT NULL,
  `ioc_value` VARCHAR(2048) NULL,
  INDEX `ioc` (`ioc_value`(255) ASC),
  INDEX `pulse` (`pulse_id` ASC),
  PRIMARY KEY (`event_id`, `pulse_id`, `ioc_hash`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- procedure delete_events
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE delete_events( tmp_table VARCHAR(64) )
BEGIN
    SET @query = CONCAT('DELETE aux FROM alienvault_siem.reputation_data aux LEFT JOIN ',tmp_table,' tmp ON tmp.id=aux.event_id WHERE tmp.id IS NOT NULL');
    PREPARE sql_query from @query;
    EXECUTE sql_query;
    DEALLOCATE PREPARE sql_query;

    SET @query = CONCAT('DELETE aux FROM alienvault_siem.otx_data aux LEFT JOIN ',tmp_table,' tmp ON tmp.id=aux.event_id WHERE tmp.id IS NOT NULL');
    PREPARE sql_query from @query;
    EXECUTE sql_query;
    DEALLOCATE PREPARE sql_query;

    SET @query = CONCAT('DELETE aux FROM alienvault_siem.idm_data aux LEFT JOIN ',tmp_table,' tmp ON tmp.id=aux.event_id WHERE tmp.id IS NOT NULL');
    PREPARE sql_query from @query;
    EXECUTE sql_query;
    DEALLOCATE PREPARE sql_query;

    SET @query = CONCAT('DELETE aux FROM alienvault_siem.extra_data aux LEFT JOIN ',tmp_table,' tmp ON tmp.id=aux.event_id WHERE tmp.id IS NOT NULL');
    PREPARE sql_query from @query;
    EXECUTE sql_query;
    DEALLOCATE PREPARE sql_query;

    SET @query = CONCAT('DELETE aux FROM alienvault_siem.acid_event aux LEFT JOIN ',tmp_table,' tmp ON tmp.id=aux.id WHERE tmp.id IS NOT NULL');
    PREPARE sql_query from @query;
    EXECUTE sql_query;
    DEALLOCATE PREPARE sql_query;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure fill_tables
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE fill_tables(
    IN date_from VARCHAR(19),
    IN date_to VARCHAR(19)
)
BEGIN
    ANALYZE TABLE acid_event; 
    IF date_from <> '' AND date_to <> '' THEN
        DELETE FROM po_acid_event WHERE timestamp BETWEEN date_from AND date_to;
        REPLACE INTO po_acid_event (select ctx, device_id, plugin_id, plugin_sid, ip_src, ip_dst, DATE_FORMAT(timestamp, '%Y-%m-%d %H:00:00'), IFNULL(src_host,0x00000000000000000000000000000000), IFNULL(dst_host,0x00000000000000000000000000000000), IFNULL(src_net,0x00000000000000000000000000000000), IFNULL(dst_net,0x00000000000000000000000000000000), count(*) FROM acid_event  WHERE timestamp BETWEEN date_from AND date_to GROUP BY 1,2,3,4,5,6,7,8,9,10,11);
        DELETE FROM ac_acid_event WHERE timestamp BETWEEN date_from AND date_to;
        INSERT INTO ac_acid_event (select ctx, device_id, plugin_id, plugin_sid, timestamp, src_host, dst_host, src_net, dst_net, sum(cnt) cnt FROM po_acid_event WHERE timestamp BETWEEN date_from AND date_to GROUP BY 1,2,3,4,5,6,7,8,9) ON duplicate key UPDATE cnt = values(cnt);
    ELSE
        TRUNCATE TABLE po_acid_event;
        REPLACE INTO po_acid_event (select ctx, device_id, plugin_id, plugin_sid, ip_src, ip_dst, DATE_FORMAT(timestamp, '%Y-%m-%d %H:00:00'), IFNULL(src_host,0x00000000000000000000000000000000), IFNULL(dst_host,0x00000000000000000000000000000000), IFNULL(src_net,0x00000000000000000000000000000000), IFNULL(dst_net,0x00000000000000000000000000000000), count(*) FROM acid_event GROUP BY 1,2,3,4,5,6,7,8,9,10,11);
        TRUNCATE TABLE ac_acid_event;
        REPLACE INTO ac_acid_event (select ctx, device_id, plugin_id, plugin_sid, DATE_FORMAT(timestamp, '%Y-%m-%d %H:00:00'), IFNULL(src_host,0x00000000000000000000000000000000), IFNULL(dst_host,0x00000000000000000000000000000000), IFNULL(src_net,0x00000000000000000000000000000000), IFNULL(dst_net,0x00000000000000000000000000000000), count(*) FROM acid_event GROUP BY 1,2,3,4,5,6,7,8,9);
    END IF;
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_tables
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE update_tables(
    IN event_id VARCHAR(32)
)
BEGIN
    SELECT ctx, device_id, DATE_FORMAT(timestamp, '%Y-%m-%d %H:00:00'), plugin_id, plugin_sid, ip_src, ip_dst, IFNULL(src_host,0x00000000000000000000000000000000), IFNULL(dst_host,0x00000000000000000000000000000000), IFNULL(src_net,0x00000000000000000000000000000000), IFNULL(dst_net,0x00000000000000000000000000000000) FROM acid_event WHERE id=UNHEX(event_id) INTO @ctx, @device_id, @timestamp, @plugin_id, @plugin_sid, @ip_src, @ip_dst, @src_host, @dst_host, @src_net, @dst_net;
    IF @plugin_id IS NOT NULL THEN
        UPDATE po_acid_event SET cnt = cnt - 1 WHERE ctx=@ctx AND device_id=@device_id AND timestamp=@timestamp AND plugin_id=@plugin_id AND plugin_sid=@plugin_sid AND ip_src=@ip_src AND ip_dst=@ip_dst AND src_host=@src_host AND dst_host=@dst_host AND src_net=@src_net AND dst_net=@dst_net AND cnt>0;
        UPDATE ac_acid_event SET cnt = cnt - 1 WHERE ctx=@ctx AND device_id=@device_id AND timestamp=@timestamp AND plugin_id=@plugin_id AND plugin_sid=@plugin_sid AND src_host=@src_host AND dst_host=@dst_host AND src_net=@src_net AND dst_net=@dst_net AND cnt>0;
    END IF;
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_events
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE get_events( 
    IN _type VARCHAR(16), -- host, network or group
    IN _table VARCHAR(64), -- tmp table name or id if host
    IN _from INT, -- 0
    IN _max INT, -- 50
    IN _order VARCHAR(32), -- timestamp desc
    search_str TEXT
)
BEGIN
    SELECT IF (_type='','host',_type) into @_type;
    SELECT IF (_from<0,0,_from) into @_from;
    SELECT IF (_max<10,10,_max) into @_max;
    SET @max = @_from + @_max;
    SELECT IF (_order='','timestamp desc',_order) into @_order;
    SELECT concat("events_",replace(uuid(), '-', '')) into @tmp_name;
    SET @ids = _table;
    SET @joins = '';
    SET @where = '';

    IF search_str <> '' THEN
        SET @joins = ', alienvault.plugin_sid';
        SET @where = CONCAT('AND acid_event.plugin_id=plugin_sid.plugin_id AND acid_event.plugin_sid=plugin_sid.sid AND plugin_sid.name LIKE "%',search_str,'%"');
    END IF;
    
    SET @query = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS ',@tmp_name,' ENGINE=MEMORY AS (SELECT * FROM alienvault_siem.acid_event LIMIT 0)');
    PREPARE stmt1 FROM @query;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @query = CONCAT('ALTER TABLE ',@tmp_name,' ADD PRIMARY KEY (id)');
    PREPARE stmt1 FROM @query;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
        
    IF _type = 'host' THEN

        SET @query = CONCAT('INSERT IGNORE INTO ',@tmp_name,' SELECT acid_event.* FROM acid_event ',@joins,' WHERE src_host=UNHEX(?) ',@where,' ORDER BY ',@_order,' LIMIT ',@max);
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1 USING @ids;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('INSERT IGNORE INTO ',@tmp_name,' SELECT acid_event.* FROM acid_event ',@joins,' WHERE dst_host=UNHEX(?) ',@where,' ORDER BY ',@_order,' LIMIT ',@max);
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1 USING @ids;
        DEALLOCATE PREPARE stmt1;

    ELSEIF _type = 'group' THEN

        SET @joins = CONCAT(@joins, ', ', @ids);

        SET @query = CONCAT('INSERT IGNORE INTO ',@tmp_name,' SELECT acid_event.* FROM acid_event ',@joins,' WHERE src_host=',@ids,'.id ',@where,' ORDER BY ',@_order,' LIMIT ',@max);
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('INSERT IGNORE INTO ',@tmp_name,' SELECT acid_event.* FROM acid_event ',@joins,' WHERE dst_host=',@ids,'.id ',@where,' ORDER BY ',@_order,' LIMIT ',@max);
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

    ELSEIF _type = 'network' THEN

        SET @joins = CONCAT(@joins, ', ', @ids);

        SET @query = CONCAT('INSERT IGNORE INTO ',@tmp_name,' SELECT acid_event.* FROM acid_event ',@joins,' WHERE src_net=',@ids,'.id ',@where,' ORDER BY ',@_order,' LIMIT ',@max);
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('INSERT IGNORE INTO ',@tmp_name,' SELECT acid_event.* FROM acid_event ',@joins,' WHERE dst_net=',@ids,'.id ',@where,' ORDER BY ',@_order,' LIMIT ',@max);
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

    END IF;

    SET @query = CONCAT('SELECT *,id as eid FROM ',@tmp_name,' ORDER BY ',@_order,' LIMIT ',@_from,',',@_max);
    PREPARE stmt1 FROM @query;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
END
$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_event_count
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE get_event_count( 
    IN _type VARCHAR(16), -- host, network or group
    IN _table VARCHAR(64), -- tmp table name or id if host
    search_str TEXT
)
BEGIN
    DECLARE events INT DEFAULT 0;
    SELECT IF (_type='','host',_type) into @_type;
    SET @ids = _table;
    SET @joins = '';
    SET @where = '';

    IF search_str <> '' THEN
        SET @joins = ', alienvault.plugin_sid';
        SET @where = CONCAT('AND acid_event.plugin_id=plugin_sid.plugin_id AND acid_event.plugin_sid=plugin_sid.sid AND plugin_sid.name LIKE "%',search_str,'%"');
    END IF;
    
    IF _type = 'host' THEN

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE src_host=UNHEX(?) ',@where,' into @event_src');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1 USING @ids;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE dst_host=UNHEX(?) ',@where,' into @event_dst');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1 USING @ids;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE src_host=UNHEX(?) AND dst_host=UNHEX(?) ',@where,' into @event_add');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1 USING @ids, @ids;
        DEALLOCATE PREPARE stmt1;

    ELSEIF _type = 'group' THEN

        SET @joins = CONCAT(@joins, ', ', @ids);

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE src_host=',@ids,'.id ',@where,' into @event_src');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE dst_host=',@ids,'.id ',@where,' into @event_dst');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE src_host=',@ids,'.id AND dst_host=',@ids,'.id ',@where,' into @event_add');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

    ELSEIF _type = 'network' THEN

        SET @joins = CONCAT(@joins, ', ', @ids);

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE src_net=',@ids,'.id ',@where,' into @event_src');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE dst_net=',@ids,'.id ',@where,' into @event_dst');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET @query = CONCAT('SELECT ifnull(sum(cnt),0) FROM ac_acid_event acid_event ',@joins,' WHERE src_net=',@ids,'.id AND dst_net=',@ids,'.id ',@where,' into @event_add');
        PREPARE stmt1 FROM @query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

    END IF;

    SET events = @event_src + @event_dst - @event_add;
    SELECT events;
END
$$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER `count_acid_event` AFTER INSERT ON `acid_event` FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
    IF @disable_count IS NULL THEN
        INSERT IGNORE INTO alienvault_siem.po_acid_event (ctx, device_id, plugin_id, plugin_sid, ip_src, ip_dst, timestamp, src_host, dst_host, src_net, dst_net, cnt) VALUES (NEW.ctx, NEW.device_id, NEW.plugin_id, NEW.plugin_sid, NEW.ip_src, NEW.ip_dst, DATE_FORMAT(NEW.timestamp, '%Y-%m-%d %H:00:00'), IFNULL(NEW.src_host,0x00000000000000000000000000000000), IFNULL(NEW.dst_host,0x00000000000000000000000000000000), IFNULL(NEW.src_net,0x00000000000000000000000000000000), IFNULL(NEW.dst_net,0x00000000000000000000000000000000),1) ON DUPLICATE KEY UPDATE cnt = cnt + 1;
        INSERT IGNORE INTO alienvault_siem.ac_acid_event (ctx, device_id, plugin_id, plugin_sid, timestamp, src_host, dst_host, src_net, dst_net, cnt) VALUES (NEW.ctx, NEW.device_id, NEW.plugin_id, NEW.plugin_sid, DATE_FORMAT(NEW.timestamp, '%Y-%m-%d %H:00:00'), IFNULL(NEW.src_host,0x00000000000000000000000000000000), IFNULL(NEW.dst_host,0x00000000000000000000000000000000), IFNULL(NEW.src_net,0x00000000000000000000000000000000), IFNULL(NEW.dst_net,0x00000000000000000000000000000000),1) ON DUPLICATE KEY UPDATE cnt = cnt + 1;
    END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
