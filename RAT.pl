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

my $gettables = "SHOW TABLES";
my $sth = $dbh->prepare($gettables);
$sth->execute() or die "SQL Error: $DBI::errstr\n";
while(my @out = $sth->fetchrow_array()){
        my $table = join('', @out);
        push(@tables, $table);
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
<div id="footer">
<div id = "table1" style="width:20%;float:left" >
<table align = "center" id = "sampletable" border = "1px">
<thead>
<tr><td align = "center" colspan="3">Table 1</td></tr> 
<th>Name</th><th>Age</th><th>Activity</th>
</thead>
<tbody>
<tr><td>Adam</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Sally</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Tom</td><td>30</td><td>Hiking</td></tr>
<tr><td>John</td><td>28</td><td>Rock Climbing</td></tr>
</tbody>
</table>
</div>
<div id = "table2" style="width:20%;float:left" >
<table align = "center" id = "sampletable" border = "1px">
<thead>
<tr><td align = "center" colspan="3">Table 1</td></tr> 
<th>Name</th><th>Age</th><th>Activity</th>
</thead>
<tbody>
<tr><td>Adam</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Sally</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Tom</td><td>30</td><td>Hiking</td></tr>
<tr><td>John</td><td>28</td><td>Rock Climbing</td></tr>
</tbody>
</table>
</div>
<div id = "table3" style="width:20%;float:left" >
<table align = "center" id="sampletable" border="1px">
<thead>
<tr><td align = "center" colspan="3">Table 1</td></tr> 
<th>Name</th><th>Age</th><th>Activity</th>
</thead>
<tbody>
<tr><td>Adam</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Sally</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Tom</td><td>30</td><td>Hiking</td></tr>
<tr><td>John</td><td>28</td><td>Rock Climbing</td></tr>
</tbody>
</table>
</div>
<div id = "table4" style="width:20%;float:left" >
<table align = "center" id = "sampletable" border = "1px">
<thead>
<tr><td align = "center" colspan="3">Table 1</td></tr> 
<th>Name</th><th>Age</th><th>Activity</th>
</thead>
<tbody>
<tr><td>Adam</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Sally</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Tom</td><td>30</td><td>Hiking</td></tr>
<tr><td>John</td><td>28</td><td>Rock Climbing</td></tr>
</tbody>
</table>
</div>
<div id = "table5" style="width:20%;float:left" >
<table align = "center" id = "sampletable" border = "1px">
<thead>
<tr><td align = "center" colspan="3">Table 1</td></tr> 
<th>Name</th><th>Age</th><th>Activity</th>
</thead>
<tbody>
<tr><td>Adam</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Sally</td><td>25</td><td>Parasailing</td></tr>
<tr><td>Tom</td><td>30</td><td>Hiking</td></tr>
<tr><td>John</td><td>28</td><td>Rock Climbing</td></tr>
</tbody>
</table>
</div>
</div>
</div>
</body>
</html>
|;

sub parseTree{
	my @query = @_;
	
}
