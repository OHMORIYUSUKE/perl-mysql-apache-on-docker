#!/usr/bin/perl

use strict;
use warnings;
use DBI;

print "Content-type: text/html\n\n";
print "<H1>Hello World Perl !!</H1>\n";

# データベース接続準備
my $dsn = "dbi:mysql:database=testdb;host=db;port=3306";
my $user = "root";
my $pass ="root";

# データベースハンドル
my $dbh = DBI->connect( $dsn, $user, $pass, {
    AutoCommit => 1,
    PrintError => 0,
    RaiseError => 1,
    ShowErrorStatement => 1,
    AutoInactiveDestroy => 1
})|| die $DBI::errstr;