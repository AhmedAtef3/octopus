#!/usr/bin/bash

# @file octopus.sh
# @brief A script that handles the UI with the user where it process all requires queries and runs the corresponding scripts.
# @noargs
# -------------------------------------------------------------------------------------------------------

#Source the script containing test functions
source $HOME/octopus/test.sh

#Set a prompt for the program
prompt="octopusDB [(none)] >  "


#Variables used to print in bold
bold=$(tput bold)
normal=$(tput sgr0)


#check if octopusdb doens't exist then create one 
test -d $HOME/octopusdb
if [ $? -eq 1 ]
then 
	mkdir $HOME/octopusdb
	touch $HOME/octopusdb/databases.d
	touch $HOME/octopusdb/databases.md
	echo "Databases" > $HOME/octopusdb/databases.md
fi


#A function that displays options for tables operations inside a selected database
function TableMenu {
	while true
	do
	
        	clear
		#Print menu and read input from user
		echo "Welcome to the OctopusDB monitor."
   		echo -e "(1)  ListTables        (2)  CreateTable\n(3)  DropTable         (4)  InsertRecord\n(5)  DeleteRecord      (6)  UpdateRecord\n(7)  SelectRecord      (8)  ShowTable\n(9)  ExitDatabase      (10) ExitProgram    \n(11) Manual"
   		
   		echo -n ${prompt}
        	read choice

		case $choice in
        		1) #listTables
        		bash $HOME/octopus/listTables.sh
        		echo "Press any key to continue .."
      			read -n1
      			clear
        		;;
        	
        		2) #createTable
        		echo -n "${bold}Table name : ${normal}"
      			read name
     			echo  -n "${bold}Columns and datatypes : ${normal}"
      			read columns     			
      			bash $HOME/octopus/createTable.sh ${name} "${columns}"
      			echo "Press any key to continue .."
      			read -n1
      			clear
      			;;
      		
        		3) #dropTable
        		echo -n "${bold}Table name : ${normal}"
      			read
      			bash $HOME/octopus/dropTable.sh $REPLY
      			echo "Press any key to continue .."
      			read -n1
      			clear
      			;;
      		
      			4) #insertRecord
      			echo -n "${bold}Table name : ${normal}"
      			read tableName
      			echo -n "${bold}Record : ${normal}"
      			read record
      			bash $HOME/octopus/insertRecord.sh ${tableName} ${record}
	      		echo "Press any key to continue .."
	      		read -n1
      			clear
	      		;;
	      		
	      		5) #deleteRecord
      			echo -n "${bold}Table name : ${normal}"
	      		read tableName
      			echo -n "${bold}Conditions : ${normal}"
	      		read record
	      		bash $HOME/octopus/deleteRecord.sh ${tableName} ${record}
	      		echo "Press any key to continue .."
	      		read -n1
	      		clear
	      		;;
	      		
	      		6) #updateRecord
      			echo -n "${bold}Table name : ${normal}"
	      		read tableName
      			echo -n "${bold}Conditions : ${normal}"
	      		read record
	      		echo -n "${bold}Updated value : ${normal}"
	      		read updated
	      		bash $HOME/octopus/updateRecord.sh ${tableName} ${record} ${updated}
	      		echo "Press any key to continue .."
	      		read -n1
	      		clear
	      		;;
	      		
	      		7) #selectRecord
      			echo -n "${bold}Table name : ${normal}"
	      		read tableName
      			echo -n "${bold}Conditions : ${normal}"
	      		read record
	      		bash $HOME/octopus/selectRecord.sh ${tableName} ${record}
	      		echo "Press any key to continue .."
	      		read -n1
	      		clear
	      		;;
	      		
	    		8) #showTable
      			echo -n "${bold}Table name : ${normal}"
	      		read tableName
	      		bash $HOME/octopus/showTable.sh ${tableName}
	      		echo "Press any key to continue .."
	      		read -n1
	      		clear
	      		;;
	      		
	    		9) #exitDatabase
	      		cd $HOME/octopusdb
	      		prompt="octopusDB [(none)] > "
	      		break
	      		;;
	      		
	      		10) #exitProgram
      			exit
      			;;
      			
      			11) #Help
      			bash $HOME/octopus/help.sh 
      			echo "Press any key to continue .."
      			read -n1
      			;;
      			
      			
			*) echo "Invalid option."
   		esac
	done
}



while true
do

	#clear Terminal
	clear
	
	#Print menu and read input from user
	echo "Welcome to the OctopusDB monitor."
	echo -e "(1) CreateDatabase\n(2) OpenDatabase\n(3) DropDatabase\n(4) ListDatabases\n(5) ExitProgram\n(6) Manual "
   	echo -n ${prompt}
        read choice
        echo ""

	case $choice in
        	1) #createDB
      		echo -n "${bold}Database name : ${normal}"
      		read
      		bash $HOME/octopus/createDB.sh $REPLY
      		echo "Press any key to continue .."
      		read -n1
      		;;
    		2) #useDB
      		echo -n "${bold}Database name : ${normal}"
      		read
      		source $HOME/octopus/openDB.sh $REPLY
      		if [ "${rCode}" = "0" ]
      			then
        		TableMenu
      		else
      			echo "Press any key to continue .."
      			read -n1
		fi
      		;;
      		
    		3) #dropDB
      		echo -n "${bold}Database name : ${normal}"
      		read
      		bash $HOME/octopus/dropDB.sh $REPLY
      		echo "Press any key to continue .."
      		read -n1
      		;;
      		
    		4) #listDB
      		bash $HOME/octopus/listDB.sh
      		echo "Press any key to continue .."
      		read -n1
      		;;
      		
      		5)
      		exit
      		;;
      		
      		6)
      		bash $HOME/octopus/help.sh DB
      		echo "Press any key to continue .."
      		read -n1
      		;;
      		
        	*) echo "Invalid option."
   	esac
done
