#!/usr/local/cpanel/3rdparty/bin/perl
#
use CGI;
use DBI;
use Encode;

my $cgi = new CGI;
my $query = $cgi->param('RAquery');
#my $query = decode_utf8($cgi->param('RAquery'));
my $operator = $cgi->param('operator');
$operator = ord($cgi->param('operator'));
#my $operator = decode_utf8($cgi->param('operator'));
$query = $query.$operator;

my $SQLquery;

my $database = "interconnect_relAlgebra";
my $host = 'engr-cpanel-mysql.engr.illinois.edu';
my $user = 'interconnect_sa';
my $passwd = 'interconnect13';
my $port = "3306";

my $dbh = DBI->connect("DBI:mysql:$database:$host:$port", $user, $passwd, { RaiseError => 1, AutoCommit => 1});

my @tables;

my $gettables = "SHOW TABLES";
my $sth = $dbh->prepare($gettables);
$sth->execute() or die "SQL Error: $DBI::errstr\n";
while(my @out = $sth->fetchrow_array()){
        my $table = join('', @out);
        push(@tables, $table);
}

my ($table1,$table2,$op);

sub parseQuery{
	foreach(@tables){
		if ($table2){
			if ($query =~ /($_)/){
                                $table1 = $1;
                        }
		}
		else{
			if ($query =~ /($_)/){
				$table2 = $1;
			} 
		}
	}
	if ($query =~ /(&#961)/){
		$op = "NATURAL JOIN";
	}
}

if ($query){
	parseQuery;
	$SQLquery = "SELECT * FROM $table1 $op $table2";
}


print "Content-type: text/html; charset=utf-8\n";
print qq|
<html>

<head>
<title>Query</title>
<link href="RAT.css" type="text/css" rel="stylesheet">
</head>

<body>

<form method="get" name="RelAlgebra">
<div id = "container">
<div id = "sqlquerybox" style="width:40%;float:right">
<input type="text" name="SQLquery" style = "height:100px;width=1000px" value = "$query.$SQLquery"><br>
</div>
<div id = "querybox" style="width:40%;float:right">
<input type="text" name="RAquery" style = "height:100px;width=1000px" value = $query><br>
<input type="submit" value="Submit">
</div>
<div id = "operators" style="width:20%;float:left">
<table align = "center" id="sampletable" border = "1px">
<tbody>
<tr><td><input type="submit" name="operator" title = "Union" value=&#x22c3></td><td><input type="submit" title = "Intersection" name="operator" value=&#x22c2></td></tr>
<tr><td><input type="submit" name="operator" title="Natural Join" value=&#x22c8></td><td><input type="submit" name="operator" title="Rename" value=&#961></td></tr>
<tr><td><input type="submit" name="operator" title = "Projection" value=&#960></td><td><input type="submit" name="operator" title = "Selection" value=&#963></td></tr>
<tr><td><input type="submit" name="operator" title = "AND" value=&#x2227></td><td><input type="submit" name="operator" title = "OR" value=&#x2228></td></tr>
<tr><td><input id="operators" value="&#x22c3" onclick="javascript:updateData('a');" type="button"></td><td><input id="operators" value="&#x22c2" onclick="javascript:updateData('a');" type="button"></td>
<tr><td><input id="operators" value="&#x22c8" onclick="javascript:updateData('a');" type="button"></td><td><input id="operators" value="&#961" onclick="javascript:updateData('a');" type="button"></td>
<tr><td><input id="operators" value="&#960" onclick="javascript:updateData('a');" type="button"></td><td><input id="operators" value="&#963" onclick="javascript:updateData('a');" type="button"></td>
<tr><td><input id="operators" value="&#x2227" onclick="javascript:updateData('a');" type="button"></td><td><input id="operators" value="&#x2228" onclick="javascript:updateData('a');" type="button"></td>
</tbody>
</div>
</div>
</form>
<script>
operators = [];
function updateData(val){operands.push(val);}
</script>
</body>
</html>|;



sub union{
	
}

sub intersect{

}
