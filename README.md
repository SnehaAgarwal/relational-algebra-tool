Relational Algebra Tool *with SQL equivalent of the RAT query*
----------------------------------------------------------------------

This tool is developed as a part of the 'pfun (programming fun)' in CS411, Fall 2013 at UIUC.

1. The tool runs relational algebra queries to give the resulting tables. 
2. The logic behind this is that it takes a relational algebra query, converts it into a SQL query and then, runs the SQL query. 
3. It is based on the tables located in a database hosted on cPanel. Hence, the tables can be modified anytime in the database. 
4. The current state of the tables are shown at the bottom of the page.

How to use
----------

1. To insert an operator, operand or condition, click on the corresponding button.
2. Select the tables you want to operate on, from the dropdown list of tables.
3. Select the operator you want to use from the list of operators.
4. Write the condition in the textbox that appears when `Insert Condition` is clicked.
5. Click on the `Submit` button to run query!

Syntax Notes
-------------

Due to time constraints, only one operator can be run successfully by the relational algebra tool.
So, only insert ONE operator and its corresponding operands/conditions.
For rename, the condition follows the format `TableName(Attr1,Attr2,...AttrN)` where the attributes listed are the new names for the attributes (listed in the same order as in the table columns). The table name cannot be altered in the given implementation.
For selection, rename, and projection, put the condition right after the operator, followed by the table.
For all binary operators, follow the usual RA format: table operator table.
If you want to remove a condition, clear the condition box and click somewhere else.
If you want to remove a table or operator, choose `None` in the selection box.
 
Additional feature
------------------

After you submit the Relational Algebra query, you can also see the equilavent query in MySQL.

Scope of Improvement
--------------------

Due to time constraints, the tool could only be developed to handle basic queries. It can be extended to handle complex queries.

Team Contributions
--------------------

*Timothy Thorp*

1. Creating tables
2. Functions for creating different SQL queries for corresponding RA queries

*Sneha Agarwal*

1. Front end
2. Parsing of RA queries from front end
3. Sending query to SQL convertor
4. Sending SQL query to backend
5. Getting results from backend and printing it
 

