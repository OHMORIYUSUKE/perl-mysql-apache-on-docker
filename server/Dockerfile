# PerlとApacheを含むベースイメージを使用
FROM ubuntu:22.04

# 必要なパッケージを更新・インストール
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    perl \
    cpanminus \
    libmysqlclient-dev \
    make \
    gcc \
    && apt-get clean

COPY localhost.conf /etc/apache2/sites-enabled/localhost.conf

# ApacheのCGIモジュールを有効にし、CGIスクリプトのディレクトリを設定
RUN a2enmod cgi

# cpanm を使用して必要な Perl モジュールをインストール
RUN cpanm CGI DBI DBD::mysql

COPY ./app /var/www/html

# デフォルトの作業ディレクトリを/var/www/htmlに設定
WORKDIR /var/www/html

RUN chmod 777 /var/www/html/
RUN chmod 777 /usr/bin/perl

# Webサーバーへのアクセス用にポート80を公開
EXPOSE 80

# Apacheをフォアグラウンドで起動
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
