#!/usr/bin/bash

# @file createDB.sh
# @brief A script that creates a new database in your system.  
# @example
#    ./createDB.sh dbName
# @arg $1 Database Name: should not contain any characters or contain only numbers.
# @exitcode 0 If successfully created a new database.
# @exitcode 1 If there is a syntax error in arguments or database name is not valid or database exists.
# ------------------------------------------------------------------------------------------------------


#Source the script containing test functions
source $HOME/octopus/test.sh


#Print an error if no args or too many args are given, or db name contains only numbers or contains any character
if argsCheck ${#} 1 || validName ${1}
then 
	echo "ERROR: You have an error in your syntax, check the manual for the right syntax."
	exit 1

#Check if database already exists
elif dbExist ${1}
then
	echo "ERROR: Can't create database '${1}'. Database exists."
	exit 1	
else
	#Create Directory For the database
	mkdir $HOME/octopusdb/${1}

	#Create two directories for data and metadata of of tables
	mkdir $HOME/octopusdb/${1}/data
	mkdir $HOME/octopusdb/${1}/metadata
	
	#create two files that contain list of tables and tables metadata inside database metadata
	touch $HOME/octopusdb/${1}/tables.d
	touch $HOME/octopusdb/${1}/tables.md
	
	#Add data to tables file metadata
	echo "Tables_in_${1}" > $HOME/octopusdb/${1}/tables.md
	
	#Add database to databases list
	echo "${1}" >> $HOME/octopusdb/databases.d
	
	echo "${bold}Query Ok.${normal}"
	exit 0
fi

