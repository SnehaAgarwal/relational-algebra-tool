#!/usr/local/cpanel/3rdparty/bin/perl
#
#
use CGI;
use DBI;
use Encode;
use Switch;

my $cgi = new CGI;
my $query = $cgi->param('RAquery');
my @terms = $cgi->param('operator');
my @operands = $cgi->param('operand');

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

my @conditions;
my $op_len = $#terms;
my @operators = ('union','intersect','join','rename','projection','selection');

sub parseQuery{
	my $operator;
	foreach(@terms){
		$operator = grep(/$_/,@operators);
		@get_tables = grep(/$_/,@tables) ;
	}
	switch($operator){
		case "union" {my_union;}
		case "intersect" {my_intersect;}
		case "join" {my_join;}
		case "rename" {my_rename;}
		case "projection" {my_projection;}
		case "selection" {my_selection}
	}	
	if ($operator[i])
	my @conditions = ( $query =~ /\((.*)\)/g )
	foreach(@terms)
	{
		
	}
}


if ($query){
	parseQuery;
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
<input type="text" name="SQLquery" style = "height:100px;width=1000px" value = "$oper"><br>
</div>
<div id = "querybox" style="width:40%;float:right">
<input type="text" name="RAquery" style = "height:100px;width=1000px" value = $query><br>
<input type="submit" value="Submit">
</div>
<div id = "operators" style="width:20%;float:left">
<table align = "center" id="sampletable" border = "1px">
<tr><td><input type="button" value="Insert Operator"></td>
<td><input type="button" value="Insert Table"></td></tr>
</table>
<table align = "center" id="sampletable" border = "1px">
<tr><td><select name = "operator">
  <option value="op">Select Operator</option>
  <option value="union">&#x22c3</option>
  <option value="intersect">&#x22c2</option>
  <option value="join">&#x22c8</option>
  <option value="rename">&#961</option>
  <option value="projection">&#960</option>
  <option value="selection">&#963</option>
</select><select name = "operator">
  <option value="op">Select Operator</option>
  <option value="union">&#x22c3</option>
  <option value="intersect">&#x22c2</option>
  <option value="join">&#x22c8</option>
  <option value="rename">&#961</option>
  <option value="projection">&#960</option>
  <option value="selection">&#963</option>
</select></td>
<td><select name = "">
  <option value="table">Select Table</option>|;
  foreach (@tables){
	print qq|<option value="$_">$_</option>|;
  }
print qq|</select></td></tr>
</table>
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
	my ($table1, $table2) = @_;
	my $SQLquery = "SLECT * FROM $table1 UNION $table2";
	return $query;
}

sub intersect{
	
}
