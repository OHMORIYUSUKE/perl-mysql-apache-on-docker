--
-- テーブルの構造 `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (id)
);

--
-- テーブルのデータのダンプ `user`
--

INSERT INTO `user` (`name`) VALUES
('Amami Haruka'),
('Kasuga Mirai'),
('Shimamura Uzuki'),
('高坂 穂乃果'),
('高海 千歌'),
('上原 歩夢');
