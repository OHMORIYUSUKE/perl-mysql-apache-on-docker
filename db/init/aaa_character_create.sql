-- アイドルマスター キャラクターデータ
SET NAMES utf8mb4;
USE `fuel_dev`;

-- 既存テーブルの削除
DROP TABLE IF EXISTS `imas_characters`;

-- テーブル定義
CREATE TABLE IF NOT EXISTS `imas_characters` (
       `id` INT NOT NULL AUTO_INCREMENT COMMENT '連番ID',
       `type` VARCHAR(100) NOT NULL COMMENT 'キャラクターの所属',
       `ch_name` VARCHAR(50) NOT NULL COMMENT 'キャラクターのフルネーム',
       `ch_name_ruby` VARCHAR(100) NOT NULL COMMENT 'アイドルのフルネームのよみがな',
       `ch_family_name` VARCHAR(20) NOT NULL COMMENT 'キャラクターの苗字',
       `ch_family_name_ruby` VARCHAR(50) NOT NULL COMMENT 'キャラクターの苗字のよみがな',
       `ch_first_name` VARCHAR(20) NOT NULL COMMENT 'キャラクターの名前',
       `ch_first_name_ruby` VARCHAR(50) NOT NULL COMMENT 'キャラクターの名前のよみがな',
       `ch_birth_month` TINYINT NOT NULL COMMENT 'キャラクターの誕生月',
       `ch_birth_day` TINYINT NOT NULL COMMENT 'キャラクターの誕生日',
       `ch_gender` TINYINT NOT NULL COMMENT 'キャラクターの性別 0:男 1:女',
       `is_idol` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'アイドルかどうか（0: いいえ、1: はい）',
       `ch_blood_type` VARCHAR(10) DEFAULT NULL COMMENT '血液型',
       `ch_color` VARCHAR(20) DEFAULT NULL COMMENT 'キャラクターのイメージカラー',
       `cv_name` VARCHAR(50) DEFAULT NULL COMMENT '声優さんのフルネーム',
       `cv_name_ruby` VARCHAR(100) DEFAULT NULL COMMENT '声優さんのフルネームのよみがな',
       `cv_family_name` VARCHAR(20) DEFAULT NULL COMMENT '声優さんの苗字',
       `cv_family_name_ruby` VARCHAR(50) DEFAULT NULL COMMENT '声優さんの苗字のよみがな',
       `cv_first_name` VARCHAR(20) DEFAULT NULL COMMENT '声優さんの名前',
       `cv_first_name_ruby` VARCHAR(50) DEFAULT NULL COMMENT '声優さんの名前のよみがな',
       `cv_birth_month` TINYINT DEFAULT NULL COMMENT '声優さんの誕生月',
       `cv_birth_day` TINYINT DEFAULT NULL COMMENT '声優さんの誕生日',
       `cv_gender` TINYINT DEFAULT NULL COMMENT '声優さんの性別 0:男 1:女',
       `cv_nickname` VARCHAR(50) DEFAULT NULL COMMENT '声優さんの愛称',
       PRIMARY KEY (`id`),
       INDEX `idx_ch_name` (`ch_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT = 'キャラクターデータ';
