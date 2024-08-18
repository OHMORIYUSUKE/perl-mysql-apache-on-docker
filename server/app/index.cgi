#!/usr/bin/perl

use CGI;
use strict;
use warnings;
use DBI;
use Encode;

# データベース接続準備
my $dsn  = "dbi:mysql:database=fuel_dev;host=db;port=3306";
my $user = "root";
my $pass = "root";

# データベースハンドル
my $dbh = DBI->connect(
    $dsn, $user, $pass,
    {
        AutoCommit           => 1,
        PrintError           => 0,
        RaiseError           => 1,
        ShowErrorStatement   => 1,
        AutoInactiveDestroy  => 1,
        mysql_enable_utf8mb4 => 1
    }
) or die $DBI::errstr;

$dbh->do("set names utf8mb4");

my $query = CGI->new;
$query->charset('UTF-8')
  ;    # フォームデータのエンコーディングを UTF-8 に設定

# PATH_INFO からパスを取得
my $path_info = $query->path_info();
$path_info =~ s/^\/search\///;    # 「/search/」を取り除く

# パスパラメータを分割
my @path_parts = split( '/', $path_info );

# デフォルト値
my $ch_name       = '';
my $cv_name       = '';
my $ch_blood_type = '%';
my $type          = '%';

# パスパラメータを読み込む
for ( my $i = 0 ; $i < @path_parts ; $i += 2 ) {
    my $param_name = $path_parts[$i];
    my $param_value = decode( 'UTF-8', $path_parts[ $i + 1 ] || '' );

    if ( $param_name eq 'ch_name' ) {
        $ch_name = $param_value;
    }
    elsif ( $param_name eq 'cv_name' ) {
        $cv_name = $param_value;
    }
    elsif ( $param_name eq 'ch_blood_type' ) {
        $ch_blood_type = $param_value;
    }
    elsif ( $param_name eq 'type' ) {
        $type = $param_value;
    }
}

# ヘッダー出力
print "Content-Type: text/html; charset=UTF-8;\n\n";
print "<html lang='ja'>";
print "<head>
        <title>アイドル名簿</title>
        <link rel='stylesheet' href='/style/main.css'>
        <script src='/scripts/main.js'></script>
        </head>";
print "<body>";

print "<div class='blocktext'>";
print '<div class="container">';
print '<FORM id="search-form" method="post" class="container">';

# フォーム出力
print '<div style="margin: 10px">';
print "<h5>アイドルの名前</h5>";
print '<INPUT type="text" id="ch_name" name="ch_name" value="',
  escape_html($ch_name), '">';
print "</div>";

print '<div style="margin: 10px">';
print "<h5>声優の名前</h5>";
print '<INPUT type="text" id="cv_name" name="cv_name" value="',
  escape_html($cv_name), '">';
print "</div>";

print '<div style="margin: 10px">';
print "<h5>血液型</h5>";
print '<select id="ch_blood_type" name="ch_blood_type">';
print "<option value=''>指定なし</option>";
my $sth = $dbh->prepare("SELECT DISTINCT ch_blood_type FROM imas_characters");
$sth->execute();
while ( my $ary_ref = $sth->fetchrow_arrayref ) {
    my ($data) = @$ary_ref;
    print_option( $data, $ch_blood_type );
}
print "</select>";
print "</div>";

print '<div style="margin: 10px">';
print "<h5>グループ</h5>";
print '<select id="type" name="type">';
print "<option value=''>指定なし</option>";
$sth = $dbh->prepare("SELECT DISTINCT type FROM imas_characters");
$sth->execute();
while ( my $ary_ref = $sth->fetchrow_arrayref ) {
    my ($data) = @$ary_ref;
    print_option( $data, $type );
}
print "</select>";
print "</div>";

print '<div style="margin: 10px; margin-top: auto;">';
print "<button type='button' onclick='updatePath()'>検索</button>";
print "</div>";

print "</FORM>";
print "</div>";
print "</div>";

print "<div class='blocktext' style='margin-top: 10px;'>";

# 検索結果出力
print_results( $dbh, $ch_name, $cv_name, $ch_blood_type, $type );
print "</div>";

print "</body>";
print "</html>";

# オプション出力サブルーチン
sub print_option {
    my ( $data, $selected ) = @_;
    my $selected_attr = ( $data eq $selected ) ? ' selected' : '';
    print '<option value="', escape_html($data), '"', $selected_attr, '>',
      escape_html($data), "</option>";
}

# HTML エスケープサブルーチン
sub escape_html {
    my $text = shift;
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/"/&quot;/g;
    $text =~ s/\'/&#39;/g;
    return $text;
}

# 検索結果出力サブルーチン
sub print_results {
    my ( $dbh, $ch_name, $cv_name, $ch_blood_type, $type ) = @_;

    # 条件がすべて空の場合は全てのレコードを取得
    my $sql_query =
      (      $ch_name eq ''
          && $cv_name eq ''
          && $ch_blood_type eq '%'
          && $type eq '%' )
      ? "SELECT * FROM imas_characters"
      : "SELECT * FROM imas_characters WHERE 
                        (ch_name LIKE ? OR ch_name_ruby LIKE ?) 
                        AND (cv_name LIKE ? OR cv_name_ruby LIKE ?) 
                        AND ch_blood_type LIKE ? 
                        AND type LIKE ?";

    my $sth = $dbh->prepare($sql_query);
    if ( $sth->err ) {
        print
"<p>ステートメントの準備中にエラーが発生しました: ",
          $sth->errstr, "</p>";
        return;
    }

    if (   $ch_name eq ''
        && $cv_name eq ''
        && $ch_blood_type eq '%'
        && $type eq '%' )
    {
        $sth->execute();
    }
    else {
        $sth->bind_param( 1, "%$ch_name%" );
        $sth->bind_param( 2, "%$ch_name%" );
        $sth->bind_param( 3, "%$cv_name%" );
        $sth->bind_param( 4, "%$cv_name%" );
        $sth->bind_param( 5, $ch_blood_type );
        $sth->bind_param( 6, $type );

        if ( $sth->err ) {
            print
"<p>パラメータのバインド中にエラーが発生しました: ",
              $sth->errstr, "</p>";
            return;
        }

        $sth->execute();
        if ( $sth->err ) {
            print
"<p>ステートメントの実行中にエラーが発生しました: ",
              $sth->errstr, "</p>";
            return;
        }
    }

    while ( my $ary_ref = $sth->fetchrow_arrayref ) {
        my (
            $id,            $type,               $ch_name,
            $ch_name_ruby,  $ch_family_name,     $ch_family_name_ruby,
            $ch_first_name, $ch_first_name_ruby, $ch_birth_month,
            $ch_birth_day,  $ch_gender,          $is_idol,
            $ch_blood_type, $ch_color,           $cv_name,
            $cv_name_ruby,  $cv_family_name,     $cv_family_name_ruby,
            $cv_first_name, $cv_first_name_ruby, $cv_birth_month,
            $cv_birth_day,  $cv_gender,          $cv_nickname
        ) = @$ary_ref;
        print "<div>";
        print "<p class='character'><b>", $id, "</b>　", escape_html($type),
          "</p>\n";
        print "<p class='character'>　　 <ruby><rb>", escape_html($ch_name),
          "<rb><rp>（</rp><rt>", escape_html($ch_name_ruby),
          "</rt><rp>）</rp></ruby>　", $ch_birth_month, "月", $ch_birth_day,
          "日生まれ　", $ch_gender == 1 ? "女性" : "男性", "　",
          $is_idol == 1 ? "アイドル" : "アイドル以外", "　",
          escape_html($ch_blood_type), "型", "</p>";
        if ($cv_name) {
            print "<p class='character'>　　 CV：<ruby><rb>",
              escape_html($cv_name),      "<rb><rp>（</rp><rt>",
              escape_html($cv_name_ruby), "</rt><rp>）</rp></ruby>　",
              $cv_birth_month, "月", $cv_birth_day, "日生まれ", "　",
              $cv_gender == 1 ? "女性" : "男性", "</p>";
        }
        print "</div>";
        print "<hr>";
    }

    if ( $sth->rows == 0 ) {
        print "<p class='character'>結果がありません。</p>";
    }
}
