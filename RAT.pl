#!/usr/local/cpanel/3rdparty/bin/perl

use CGI;
use DBI;

my $database = "interconnect_relAlgebra";
my $host = 'engr-cpanel-mysql.engr.illinois.edu';
my $user = 'interconnect_sa';
my $passwd = 'interconnect13';
my $port = "3306";

my $dbh = DBI->connect("DBI:mysql:$database:$host:$port", $user, $passwd, { RaiseError => 1, AutoCommit => 1});

my $cgi = new CGI;
my @operators = $cgi->param('operators');
my @operands = $cgi->param('operands');
my @conditions = $cgi->param('conditions');

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

#my @conditions;
my $op_len = $#terms;
my @operatorlist = ('union','intersect','join','rename','projection','selection');

my $SQLquery;

sub parseQuery{
	if ($operators[0] eq "union"){
		$SQLquery = my_union($operands[0],$operands[1]);}
	elsif($operators[0] eq "intersect"){
		$SQLquery = my_intersect($operands[0],$operands[1]);}
	elsif($operators[0] eq "join"){
		$SQLquery = my_join($operands[0],$operands[1]);}
	elsif($operators[0] eq "cartesian"){
		$SQLquery =  my_cart_product($operands[0],$operands[1]);}
	elsif($operators[0] eq "difference"){
		$SQLquery =  my_difference($operands[0],$operands[1]);}
	elsif($operators[0] eq  "rename" ){
		$SQLquery = my_rename($conditions[0],$operands[1]);}
	elsif($operators[0] eq  "projection" ){
		$SQLquery = my_projection($conditions[0],$operands[1]);}
	elsif($operators[0] eq  "selection" ){
		$SQLquery = my_selection($conditions[0],$operands[1]);}
	if ($SQLquery){runQuery($SQLquery);} 
}

parseQuery;

$term = $term.join(', ', @operands);
$term = $term.$operators[0];
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
<div id="templates" style="display:none;"><select name = "operators" id="operator-select">
<option value="op">Select Operator</option>
<option value="union" title = "union">&#x22c3</option>
<option value="intersect" title = "intersection">&#x22c2</option>
<option value="join" title = "natural join">&#x22c8</option>
<option value="cartesian" title = "cartesian product">&#9587</option>
<option value="difference" title = "difference">&#45</option>
<option value="rename" title="rename">&#961</option>
<option value="projection" title = "projection">&#960</option>
<option value="selection" title = "selection">&#963</option>
<option value="0" title = "remove operator">None</option>
</select>

<select name = "operands" id="operand-select">
<option value="table">Select Table</option>|;
foreach(@tables){
	print qq|
<option value="$_">$_</option>|;
}
print qq|<option value="0" title = "remove table">None</option>
</select>

<input type="text" name="conditions" id="conditions" value="0"/>

</div>
<form method="get" name="RelAlgebra">
<div id = "container">
<div id = "sqlquerybox" style="width:100%;">
<p>Equivalent SQL query: </p>
<textarea disabled name="SQLquery" rows="4" cols="100">$SQLquery</textarea><br>
</div>
<div id = "querybox" style="width:40%;">
<input type="hidden" name="RAquery" style = "height:100px;width=1000px" value = "$term"><br>
<input type="submit" value="Submit">
</div>
<div id = "operators" style="width:20%;">
<table align = "center" id="sampletable" border = "1px">
<tr>
<td><input type="button" value="Insert Table" id="insert-tbl"></td>
<td><input type="button" value="Insert Operator" id="insert-op"></td>
<td><input type="button" value="Insert Condition" id="insert-cnd"></td>
</tr>
</table>

</div>
</div>
<div id="makequery" style="height:200px; width: 800px;background-color:blue;"></div>
</form>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script>
jQuery("#templates #operator-select").change(function(){
        if(jQuery(this).val()=="0"){
                jQuery(this).remove();
        }
});
jQuery("#templates #operand-select").change(function(){
        if(jQuery(this).val()=="0"){
                jQuery(this).remove();
        }
});
jQuery("#templates #conditions").change(function(){
        if(jQuery(this).val()==""){
                jQuery(this).remove();
        }
});
jQuery("#insert-op").click(function(){
jQuery("#makequery").append(jQuery("#templates #operator-select").clone(true));
});
jQuery("#insert-tbl").click(function(){
jQuery("#makequery").append(jQuery("#templates #operand-select").clone(true));
});
jQuery("#insert-cnd").click(function(){
jQuery("#makequery").append(jQuery("#templates #conditions").clone(true));
});
</script>
<script>
operators = [];
function updateData(val){operands.push(val);}
</script>

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

sub runQuery{
	
	my $sth = $dbh->prepare($SQLquery) or die "Cannot prepare: " . $dbh->errstr();
	$sth->execute() or die "SQL Error: $DBI::errstr\n";
	my $tabledata;
	my @tablehead = $sth->{NAME};
	my $tmp = $tablehead[0];
	my $thead;
	foreach (@$tmp)
	{
		$thead = $thead.$_."\t";
	}
	$tablesdata{'Result'}=$thead."\n";
	if ($sth->rows){
		
		while(my @out = $sth->fetchrow_array()){
			my $tablerow = join("\t", @out);
                	$tabledata = $tabledata.$tablerow."\n";
        	}
        }
	$tablesdata{'Result'}= $tablesdata{'Result'}."\n".$tabledata;
	return;
}

sub my_union{
        my ($table1, $table2) = @_;
        my $SQLquery = "(SELECT * FROM $table1) UNION (SELECT * FROM $table2)";
        return $SQLquery;
}
 
sub my_difference{
        my ($table1, $table2) = @_;
        my $SQLquery = @_;
        my $tabledata1 = $tablesdata{$table1};
        my @tabledata1 = split("\n",$tabledata1);
        my $thead1 = $tabledata1[0];
        my @thead1 = split("\t",$thead1);
        my $attr1=$thead1[0];
        for(my $i=1; $i<$#thead1; $i++)
        {
            $attr1="$attr1".", $thead1[$i]";
}
        $SQLquery = "SELECT DISTINCT $attr1 FROM $table1 WHERE ($attr1) NOT IN (SELECT $attr1 FROM $table2)";
        return $SQLquery
}

sub my_join{
        my ($table1, $table2) = @_;
        my $SQLquery = @_;
$SQLquery = "SELECT * FROM $table1 NATURAL JOIN $table2";
        return $SQLquery;
}

sub my_intersect{
        my ($table1, $table2) = @_;
        my $tabledata1 = $tablesdata{$table1};
        my @tabledata1 = split("\n",$tabledata1);
        my $thead1 = $tabledata1[0];
        my @thead1 = split("\t",$thead1);
        my $attr1="$table1."."$thead1[0]";
for(my $i=1; $i<$#thead1; $i++)
        {
            $attr1="$attr1".", $table1.$thead1[$i]";
        }
        my $attr2=$thead1[0];
        for(my $i=1; $i<$#thead1; $i++)
        {
            $attr2="$attr2".", $thead1[$i]";
        }
        my $SQLquery = "SELECT $attr1 FROM $table1 INNER JOIN $table2 USING ($attr2)";
	return $SQLquery;
}

sub my_cart_product{
        my ($table1, $table2) = @_;
        my $SQLquery = "SELECT * FROM $table1, $table2";
        return $SQLquery;
}

sub my_rename{
        my ($newname, $table1) = @_;
        my $tabledata1 = $tablesdata{$table1};
        my @tabledata1 = split("\n",$tabledata1);
        my $thead1 = $tabledata1[0];
        my @thead1 = split("\t",$thead1);
        my @newbegin = split(/\(/,$newname);
        my @newend = split(/\)/,$newbegin[1]);
        my @newpieces = split(",",$newend[0]);
        my $attr1="$thead1[0] AS $newpieces[0]";
        for(my $i=1; $i<$#thead1; $i++)
        {
            $attr1="$attr1".", $thead1[$i] AS $newpieces[$i]";
	}
        my $SQLquery = "SELECT $attr1 FROM $table1";
        
}

sub my_projection{
        my ($condition, $table1) = @_;
        my $SQLquery = @_;
        $SQLquery = "SELECT * FROM $table1 WHERE $condition";
        return $SQLquery;
}

sub my_selection{
        my ($condition, $table1) = @_;
        my $SQLquery = @_;
        $SQLquery = "SELECT $condition FROM $table1";
        return $SQLquery;
}

