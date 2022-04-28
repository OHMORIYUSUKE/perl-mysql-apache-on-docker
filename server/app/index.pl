#!/usr/bin/perl

use CGI;
use strict;
use warnings;
use DBI;

# データベース接続準備
my $dsn = "dbi:mysql:database=fuel_dev;host=db;port=3306";
my $user = "root";
my $pass = "root";

# データベースハンドル
my $dbh = DBI -> connect($dsn, $user, $pass, {
    AutoCommit => 1,
    PrintError => 0,
    RaiseError => 1,
    ShowErrorStatement => 1,
    AutoInactiveDestroy => 1,
    mysql_enable_utf8 => 1
}) || die $DBI::errstr;

$dbh -> do("set names utf8");

my $query = CGI -> new;
# 名前検索

my $ch_name = $query -> param('ch_name');
my $cv_name = $query -> param('cv_name');
my $ch_blood_type = $query -> param('ch_blood_type');
my $type = $query -> param('type');

#
#-- --PRINT-- -- -- -
#

print "Content-Type: text/html; charset=UTF-8;\n\n";
print "<html lang='ja'>";
print "<head><title>アイマス図鑑</title><link rel='stylesheet' href='style/main.css'></head>";
print "<body>";

print "<div class='blocktext'>";

print '<div class="container">';

print '<FORM action="./" class="container">';

print '<div style="margin: 10px">';
print "<h5>アイドルの名前から検索</h5>";
print '<LABEL>名前</LABEL><INPUT type="text" name="ch_name" value="', $ch_name, '">';
print "</div>";

print '<div style="margin: 10px">';
print "<h5>声優の名前から検索</h5>";
print '<LABEL>名前</LABEL><INPUT type="text" name="cv_name" value="', $cv_name, '">';
print "</div>";

print "</div>";

print '<div class="container">';

# SQL(血液型)
my $sth = $dbh -> prepare("SELECT DISTINCT ch_blood_type FROM imas_characters");
$sth -> execute();
print '<div style="margin: 10px">';

print '<label for="ch_blood_type">血液型</label>';
print '<select id="ch_blood_type" name="ch_blood_type" size="4">';
print "<option value=''>指定なし</option>";
while (my $ary_ref = $sth -> fetchrow_arrayref) {
    my($data) = @$ary_ref;
    $data ne 0 && $data ne $ch_blood_type && print '<option value="', $data, '">', $data, "</option>";
    $data eq $ch_blood_type && print '<option value="', $data, '" selected>', $data, "</option>";
}
print "</select>";


$sth = $dbh -> prepare("SELECT DISTINCT type FROM imas_characters");
$sth -> execute();
print '<label for="type">グループ</label>';
print '<select id="type" name="type" size="3">';
print "<option value=''>指定なし</option>";
while (my $ary_ref = $sth -> fetchrow_arrayref) {
    my($data) = @$ary_ref;
    $data != $type && print '<option value="', $data, '">', $data, "</option>";
    $data == $type && print '<option value="', $data, '" selected>', $data, "</option>";
}
print "</select>";

print "<button>検索</button>";
print "</FORM>";

print "</div>";

print "</div>";


$ch_name = "%".$ch_name."%";
$cv_name = "%".$cv_name."%";
$ch_blood_type = $ch_blood_type ? $ch_blood_type : "%";
$type = $type ? $type : "%";
if ($ch_name ne "") {
    my $sth = $dbh -> prepare("SELECT * FROM imas_characters WHERE ch_name LIKE ? AND cv_name LIKE ? AND ch_blood_type LIKE ? AND type LIKE ?");
    $sth -> bind_param(1, $ch_name);
    $sth -> bind_param(2, $cv_name);
    $sth -> bind_param(3, $ch_blood_type);
    $sth -> bind_param(4, $type);
    $sth -> execute();

    while (my $ary_ref = $sth -> fetchrow_arrayref) {
        my($id, $type, $ch_name, $ch_name_ruby, $ch_family_name, $ch_family_name_ruby, $ch_first_name, $ch_first_name_ruby, $ch_birth_month, $ch_birth_day, $ch_gender, $is_idol, $ch_blood_type, $ch_color, $cv_name, $cv_name_ruby, $cv_family_name, $cv_family_name_ruby, $cv_first_name, $cv_first_name_ruby, $cv_birth_month, $cv_birth_day, $cv_gender, $cv_nickname) = @$ary_ref;
        print "<hr>";
        print "<p>", $id, "　", $type, "　<ruby><rb>", $ch_name, "<rb><rp>（</rp><rt>", $ch_name_ruby, "</rt><rp>）</rp></ruby>　", $ch_birth_month, "月", $ch_birth_day, "日生まれ　", $ch_gender == 1 ? "女性" : "男性", "　", $is_idol == 1 ? "アイドル" : "アイドル以外", "　", $ch_blood_type, "型", "</p>\n";
        $cv_name ? print "<p>　　<ruby><rb>", $cv_name, "<rb><rp>（</rp><rt>", $cv_name_ruby, "</rt><rp>）</rp></ruby>　", $cv_birth_month, "月", $cv_birth_day, "日生まれ", "　", $cv_gender == 1 ? "女性" : "男性", "</p>" : print "";
    }
} else {
    my $sth = $dbh -> prepare("SELECT * FROM imas_characters WHERE ch_name LIKE ? AND cv_name LIKE ? AND ch_blood_type LIKE ? AND type LIKE ?");
    $sth -> bind_param(1, $ch_name);
    $sth -> bind_param(2, $cv_name);
    $sth -> bind_param(3, $ch_blood_type);
    $sth -> bind_param(4, $type);
    $sth -> execute();

    while (my $ary_ref = $sth -> fetchrow_arrayref) {
        my($id, $type, $ch_name, $ch_name_ruby, $ch_family_name, $ch_family_name_ruby, $ch_first_name, $ch_first_name_ruby, $ch_birth_month, $ch_birth_day, $ch_gender, $is_idol, $ch_blood_type, $ch_color, $cv_name, $cv_name_ruby, $cv_family_name, $cv_family_name_ruby, $cv_first_name, $cv_first_name_ruby, $cv_birth_month, $cv_birth_day, $cv_gender, $cv_nickname) = @$ary_ref;
        print "<hr>";
        print "<p>", $id, "　", $type, "　<ruby><rb>", $ch_name, "<rb><rp>（</rp><rt>", $ch_name_ruby, "</rt><rp>）</rp></ruby>　", $ch_birth_month, "月", $ch_birth_day, "日生まれ　", $ch_gender == 1 ? "女性" : "男性", "　", $is_idol == 1 ? "アイドル" : "アイドル以外", "　", $ch_blood_type, "型", "</p>\n";
        $cv_name ? print "<p>　　<ruby><rb>", $cv_name, "<rb><rp>（</rp><rt>", $cv_name_ruby, "</rt><rp>）</rp></ruby>　", $cv_birth_month, "月", $cv_birth_day, "日生まれ", "　", $cv_gender == 1 ? "女性" : "男性", "</p>" : print "";
    }
}

print "</div>";

print "</body>";
print "</html>";