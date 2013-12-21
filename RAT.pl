#!/usr/local/cpanel/3rdparty/bin/perl

use CGI;
use DBI;

my $database = "interconnect_relAlgebra";
my $host = 'engr-cpanel-mysql.engr.illinois.edu';
my $user = 'interconnect_sa';
my $passwd = 'interconnect13';
my $port = "3306";

my $dbh = DBI->connect("DBI:mysql:$database:$host:$port", $user, $passwd, { RaiseError => 1, AutoCommit => 1});

my @tables;
my %tablesdata;

my $gettables = "SHOW TABLES";
my $sth = $dbh->prepare($gettables);
$sth->execute() or die "SQL Error: $DBI::errstr\n";
while(my @out = $sth->fetchrow_array()){
        my $table = join('', @out);
        push(@tables, $table);
}

foreach(@tables){
	$getattributes = "DESCRIBE $_";
	my $sth = $dbh->prepare($getattributes);
        $sth->execute() or die "SQL Error: $DBI::errstr\n";
	my $attributelist;
	while(my @out = $sth->fetchrow_array()){
		$attributelist = $attributelist.$out[0]."\t";
	}
	$tablesdata{$_}= $attributelist;
}

foreach(@tables){
	my $gettable = "SELECT * FROM $_";
	my $sth = $dbh->prepare($gettable);
	$sth->execute() or die "SQL Error: $DBI::errstr\n";
	my $tabledata;
	while(my @out = $sth->fetchrow_array()){
		my $tablerow = join("\t", @out);
		$tabledata = $tabledata.$tablerow."\n";
	}
	$tablesdata{$_}= $tablesdata{$_}."\n".$tabledata;
}

print "Content-type: text/html\n";

print qq|
<html>

<head>
<title>RAT</title>
<link href="RAT.css" type="text/css" rel="stylesheet">
</head>

<body>
<div id ="container" width = 100%>
<div id = "header">
<h1 align = "center">RAT</h1>
</div>
<div id = "query" style="width:50%;float:left">
<iframe id="iframeQuery" frameborder="0" name="view" src="getquery.pl" height = 250px width="100%"></iframe>
</div>
<div id = "query" style="width=50%;float:"left">
<iframe id="iframeQuery" frameborder="0" name="view" src="runquery.pl" width="100%"></iframe>
</div>
<div id="footer">|;
foreach (keys %tablesdata){
	my $tabledata = $tablesdata{$_};
	my @tabledata = split("\n",$tabledata);
	my $thead = $tabledata[0];
	my @thead = split("\t",$thead);
	my $col_no = $#thead+1;
	print qq|
	<div id = "$_" style="width:20%;float:left">
	<table align = "center" id = "sampletable" border = "1px">
	<thead>
	<tr><td align = "center" colspan="$col_no">$_</td></tr><tr>|;
	foreach(@thead){
		print qq|<th>$_</th>|;
	}
	print qq|</tr></thead><tbody>|;
	for (my $i = 1; $i<$#tabledata; $i++){
		my $tablerow = $tabledata[$i];
		my @tablerow = split("\t",$tablerow);
		print "<tr>";
		foreach (@tablerow){
			print qq|<td>$_</td>|;
		}
		print "</tr>";
	}
	print qq|</tbody></table></div>|;
	
}
print qq|
</div>
</div>
</body>
</html>
|;

sub parseTree{
	my @query = @_;
	
}
