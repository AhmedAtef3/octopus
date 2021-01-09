#!/bin/bash

# @file help.sh
# @brief A script that prints a User manual for the available options.
# @noargs
# -------------------------------------------------------------------------------------------------------

bold=$(tput bold)
normal=$(tput sgr0)

echo ""
echo "${bold}User Guide on Options:"
if [[ ${1} = "DB" ]]
then
	echo ""
	echo "+${bold}CreateDatabase${normal}-Creates a new data base."
	echo "|Arguments: "
	echo "| -Database Name: Name can't contain any characters or spaces and can't be all numbers."
	echo "|"
	echo "+${bold}UseDatabase${normal}-Opens an existing database to manage tables inside it."
	echo "|Arguments: "
	echo "| -Database Name: Should be an existing database."
	echo "|"
	echo "+${bold}DropDatabase${normal}-Deletes the whole database with all tables."
	echo "|Arguments: "
	echo "| -Database Name: Should be an existing database."
	echo "|"
	echo "+${bold}ExitProgram${normal}-Exits the program."
	echo ""
else
	echo ""
	echo "+${bold}ListTables${normal}-List all tables in the current database."
	echo "|"
	echo "+${bold}CreateTable${normal}-Creates a new table."
	echo "|Arguments: "
	echo "| -TableName: Name can't contain any characters or spaces and can't be all numbers."
	echo "| -Columns: Name of each column followed by it's datatype and optional PRIMARY_KEY constrain ex id INT PRIMARY_KEY,name TEXT"
	echo "|	    Only INT columns can have a PRIMARY_KEY constrain."		
	echo "|"
	echo "+${bold}DropTable${normal}-Deletes the whole table."
	echo "|Arguments: "
	echo "| -TableName: Should be an existing table."
	echo "|"
	echo "+${bold}InsertRecord${normal}-Insert a new record into the table."
	echo "|Arguments: "
	echo "| -TableName: Should be an existing table."
	echo "| -Record: Column values separated by commas."
	echo "|"
	echo "+${bold}DeleteRecord${normal}-Deletes all records that matches a value from table."
	echo "|Arguments: "
	echo "| -TableName: Should be an existing table."
	echo "| -Conditions: The conditions of the records represented in the following syntax separated by commas : COL1=VAL1,COL2=VAL2."
	echo "|"
	echo "+${bold}UpdateRecord${normal}-Updates a value of a record at a certain column."
	echo "|Arguments: "
	echo "| -TableName: Should be an existing table."
	echo "| -Conditions: The conditions of the records represented in the following syntax separated by commas : COL1=VAL1,COL2=VAL2."
	echo "| -Updatedvalue: The new value of the records at a certain column. syntax: COLUMN=VALUE."
	echo "|"
	echo "+${bold}SelectRecord${normal}-Prints specific records from a table."
	echo "|Arguments: "
	echo "| -TableName: Should be an existing table."
	echo "| -Conditions: The conditions of the records represented in the following syntax separated by commas : COL1=VAL1,COL2=VAL2."
	echo "|"
	echo "+${bold}ShowTable${normal}-Prints all records of a table."
	echo "|Arguments: "
	echo "| -TableName: Should be an existing table."
	echo "|"
	echo "+${bold}ExitDatabase${normal}-Exits the databaset."
	echo "|"
	echo "+${bold}ExitProgram${normal}-Exits the program."
	echo ""
fi


