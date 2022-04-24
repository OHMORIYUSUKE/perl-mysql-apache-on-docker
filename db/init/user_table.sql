--
-- テーブルの構造 `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `user`
--

INSERT INTO `user` (`id`, `name`) VALUES
(1, 'Amami Haruka'),
(2, 'Kasuga Mirai'),
(3, 'Shimamura Uzuki'),
(4, '高坂 穂乃果'),
(5, '高海 千歌'),
(6, '上原 歩夢');

--
-- ダンプしたテーブルのインデックス
--

--
-- テーブルのインデックス `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);