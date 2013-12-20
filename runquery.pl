#!/usr/local/cpanel/3rdparty/bin/perl
#
print "Content-type: text/html\n";

print qq|
<html>

<head>
<title>Query</title>
<link href="RAT.css" type="text/css" rel="stylesheet">
</head>

<body>

<form method="get" name="RelAlgebra" action="runquery.pl">
<input type="text" name="RAquery" style = "height:100px;width=500px" value = $query><br>
</form>
</body>
</html>|;
