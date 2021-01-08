#!/bin/bash

# @file updateRecord.sh
# @brief A script that updates specific records.
# @arg $1 Table Name.
# @arg $2 The record given in the following syntax where you can specify multiple columns: COLUMN=VALUE COLUMN=VALUE
# @arg $last The updated value given in the following syntax COLUMN=VALUE
# @exitcode 0 If successfully updated the record.
# @exitcode 1 If there is a syntax error in arguments or table doesn't exist or no database is currently used 
#    or the record doesn't exist 
# -------------------------------------------------------------------------------------------------------

# Source Script containing test functions
source $HOME/octopus/test.sh

#Check if a database is currently used.
if ! dbUsed
then
  echo "ERROR: No database selected."
  exit 1
fi
# ------------------------------------------------------------------------------------------------------
#Check if no arguments are given
if ! argsCheck ${#} 0
then
  echo "ERROR: You have an error in your syntax, check the manual for the right syntax."
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
#if only table name is given then delete the whole table
if ! argsCheck ${#} 1
then
  cat /dev/null > $HOME/octopusdb/${DIR}/data/${1}.d
  exit 0
fi
# ------------------------------------------------------------------------------------------------------
#Put input arguments into an array
ARGS=(${@})

#Extract conditions from arguments
TEMP=($(echo "${ARGS[@]:1}"))
CONDITIONS=($(echo "${TEMP[@]::${#TEMP[@]}-1}"))


#Get number of Conditions
CONDITIONS_NUM=$(echo $[${#}-2])

#Put the columns of the conditions into an array
COLS=($(echo "${CONDITIONS[@]%=*}"))

#Put the the value of each column an array
VALUES=($(echo "${CONDITIONS[@]#*=}"))

#Array containing number of field for each column to be able to access it in the data file
declare -a FIELDS
# ------------------------------------------------------------------------------------------------------
#Check that inserted fields exist in the table metadata
INDEX=0
while [ ${INDEX} -lt ${CONDITIONS_NUM} ]
do
  if ! cut -d ":" -f 1 $HOME/octopusdb/${DIR}/metadata/${1}.md | grep -x ${COLS[${INDEX}]} > /dev/null
  then
    echo "ERROR: Unknown column '"${COLS[${INDEX}]}"'."
    exit 1
  fi
  let INDEX=${INDEX}+1
done
# ------------------------------------------------------------------------------------------------------
#Get field number of each input
INDEX=0
while [ ${INDEX} -lt ${CONDITIONS_NUM} ]
do
  FIELDS+=($(cut -d ":" -f 1 $HOME/octopusdb/${DIR}/metadata/${1}.md | grep -n -x ${COLS[${INDEX}]} | cut -d ":" -f 1))
  let INDEX="${INDEX}"+1
done
# ------------------------------------------------------------------------------------------------------
#Get all records that match any of the conditions
declare -a RECORDS_LINES
INDEX=0
while [ ${INDEX} -lt ${CONDITIONS_NUM} ]
do
  RECORDS_LINES+=($(cut -d ":" -f ${FIELDS[${INDEX}]} $HOME/octopusdb/${DIR}/data/${1}.d | grep -n -x ${VALUES[${INDEX}]} | cut -d ":" -f 1))
  let INDEX=${INDEX}+1
done
# ------------------------------------------------------------------------------------------------------
#Get frequency of each unique record line

#Get unique record line numbers (remove repeated numbers) 
UNIQUE_RECORDS=($(echo "${RECORDS_LINES[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

declare -a RECORDS_FREQ
SUM=0
for RECORD in "${UNIQUE_RECORDS[@]}"
do
  for LINE in "${RECORDS_LINES[@]}"
  do
    if [[ ${RECORD} -eq ${LINE} ]]
    then
      let SUM=${SUM}+1
    fi
  done
  RECORDS_FREQ+=(${SUM})
  let SUM=0
done
# ------------------------------------------------------------------------------------------------------
#Delete the records that appeared as many times as the number of conditions
INDEX=0
for FREQ in "${RECORDS_FREQ[@]}"
do
  if [[ ${FREQ} -eq ${CONDITIONS_NUM} ]]
  then
    UPDATED_LINES+=("${UNIQUE_RECORDS[${INDEX}]}")
  fi
  let INDEX=${INDEX}+1
done

# ------------------------------------------------------------------------------------------------------

DB_DIR=$HOME/octopusdb/$DIR
UPDATED_COL=${BASH_ARGV%=*}
UPDATED_VAL=${BASH_ARGV#*=}
UPDATED_FIELD=$(grep -n "${UPDATED_COL}" $DB_DIR/metadata/${1}.md | cut -d: -f1 )
PK_FIELD=$(grep -n "PRIMARY_KEY" $HOME/octopusdb/${DIR}/metadata/${1}.md | cut -d ":" -f 1)



#-----------------------------------------------------------------------------------------------------
#Check if updated column exists
if ! cut -d ":" -f 1 $HOME/octopusdb/${DIR}/metadata/${1}.md | grep -x ${UPDATED_COL} > /dev/null
  then
    echo "ERROR: Unknown column '"${UPDATED_COL}"'."
    exit 1
fi
# ------------------------------------------------------------------------------------------------------
# Check if user is updating a primary key that already exists or is assigning same primary key for multiple records
if [ -n "${PK_FIELD}" ]
then
	if [ ${PK_FIELD} -eq ${UPDATED_FIELD} ]
	then 
  		cut -d ":" -f ${PK_FIELD} $HOME/octopusdb/${DIR}/data/${1}.d | grep -n ${UPDATED_VAL} > /dev/null
		if [ "$?" -eq 0 ]
  		then
    			echo "ERROR: Duplicate entry for key 'PRIMARY'."
    			exit 1
  		fi
  		
  		if [ ${#UPDATED_LINES[@]} -gt 1 ] 
  		then
  		    	echo "ERROR: Can't assign the same value for key 'PRIMARY' in multiple records."
    			exit 1
    		fi
         fi
fi
# ------------------------------------------------------------------------------------------------------
# Check if user is updating an int column that the value is an integer and within limits
grep  "${UPDATED_COL}" $DB_DIR/metadata/${1}.md | grep "INT" > /dev/null
INT_CHECK="$?"
    
if [ ${INT_CHECK} -eq 0 ]
   then 
      #If datatype of column is INT and Updated value contains anything but numbers raise an error
      if [[ ! ${UPDATED_VAL} =~ ^-?[0-9]+$ ]]
      then 
         echo "Incorrect integer value: ${UPDATED_VAL} for column ${UPDATED_COL}."
         exit 1
      fi

      #If datatype of column is INT and Updated value in out of INT range raise an error
      if [ ${#UPDATED_VAL} -gt 11 ]
      then
         echo "Out of range value for column ${UPDATED_COL}. "
         exit 1
       fi
       
       #If datatype of column is INT and Updated value in out of INT range raise an error
       if [ ${UPDATED_VAL} -lt -2147483648 ] || [ ${UPDATED_VAL} -gt 2147483647 ]
       then
          echo "Out of range value for column ${UPDATED_COL}. "
    	exit 1
       fi
fi

# ------------------------------------------------------------------------------------------------------
#update lines
for LINE in "${UPDATED_LINES[@]}"
do
   #update required field in the specified record and save output in a temp file
   awk 'BEGIN{FS=":"; OFS=":";} {if(NR == '${LINE}') {$'${UPDATED_FIELD}'='${UPDATED_VAL}'} print $0}'  $DB_DIR/data/${1}.d > $DB_DIR/metadata/temp.d 

   #Move temp file content to the original table to update it
   mv $DB_DIR/metadata/temp.d  $DB_DIR/data/${1}.d 
done		  
  echo "${bold}Query Ok.${normal}"
exit 0
