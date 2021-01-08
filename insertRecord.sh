#!/bin/bash

# @file selectRecord.sh
# @brief A script that add records into table as a full record.
# @arg $1 Table Name.
# @arg $n columns values.
# @exitcode 0 If successfully inserted the record.
# @exitcode 1 If there is a syntax error in arguments or no database is currently used or table doesn't exist 
#    or primary key is repeated or a datatype is invalid for the column.
# ------------------------------------------------------------------------------------------------------

# Source Script containing test functions
source $HOME/octopus/test.sh

#Check if a database is currently used.
if ! dbUsed
then
  echo "ERROR: No database selected."
  exit 1
fi

# ------------------------------------------------------------------------------------------------------
#Check if table exists in the current selected database.
if ! tableExist ${1} ${DIR}
then
  echo "ERROR: Table '"${DIR}.${1}"' doesn't exist."
  exit 1
fi

# ------------------------------------------------------------------------------------------------------
#Check number of arguments execluding table name and compare it with the number of columns in the selected table
ARGS_NUM=$(echo $[${#}-1])
COL_NUM=$(wc -l $HOME/octopusdb/${DIR}/metadata/${1}.md | cut -d " " -f1)
if [[ ${ARGS_NUM} -ne ${COL_NUM} ]]
then
  echo "ERROR: Column count doesn't match value count."
  exit 1
fi

# ------------------------------------------------------------------------------------------------------
#Check if value is integer if placed in INT or PRIMARY_KEY fields 

#Put input arguments into array
RECORD_DATA=("${@}")
#Save line numbers which contain data type INT or PRIMARY_KEY into array
INT_FIELDS=($(cut -d ":" -f 2 $HOME/octopusdb/${DIR}/metadata/${1}.md | grep -n -E "INT|PRIMARY_KEY" | cut -d ":" -f 1))
for INDEX in ${INT_FIELDS[@]}
do
  if ! intCheck ${RECORD_DATA[$INDEX]}
  then  
    echo "ERROR: Incorrect integer value: '"${RECORD_DATA[$INDEX]}"' for column '"${DIR}.${1}.$(sed -n "${INDEX}p" $HOME/octopusdb/${DIR}/metadata/${1}.md | cut -d ":" -f 1)"'."
    exit 1
  fi
done

# ------------------------------------------------------------------------------------------------------
# If a primary key exists check for duplicate entry
PK_FIELD=$(grep -n "PRIMARY_KEY" $HOME/octopusdb/${DIR}/metadata/${1}.md | cut -d ":" -f 1)
if [ -n "${PK_FIELD}" ]
then
	#Get records number in the table 
	RECORDS_NUM=$(wc -l < $HOME/octopusdb/${DIR}/data/${1}.d)
	INDEX=1
	while [ ${INDEX} -le ${RECORDS_NUM} ]
	do
  		PK_VALUE=$(sed -n "${INDEX}p" $HOME/octopusdb/${DIR}/data/${1}.d | cut -d ":" -f ${PK_FIELD})
  		if [[ ${RECORD_DATA[${PK_FIELD}]} -eq ${PK_VALUE} ]]
  		then
    			echo "ERROR: Duplicate entry '"${RECORD_DATA[${PK_FIELD}]}"' for key 'PRIMARY'."
    			exit 1
  		fi
  		let INDEX=${INDEX}+1
	done 
fi
# ------------------------------------------------------------------------------------------------------
#Insert the record into the table
INDEX=1
while [[ ${INDEX} -le ${ARGS_NUM} ]]
do 
  echo -n "${RECORD_DATA[${INDEX}]}" >> $HOME/octopusdb/${DIR}/data/${1}.d
  if [[ ${INDEX} -lt ${ARGS_NUM} ]]
  then
    echo -n ":" >> $HOME/octopusdb/${DIR}/data/${1}.d
  fi
  let INDEX=${INDEX}+1
done

echo -e -n "\n" >> $HOME/octopusdb/${DIR}/data/${1}.d
echo "${bold}Query Ok.${normal}"
exit 0
