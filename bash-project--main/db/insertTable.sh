#!/bin/bash

cd "$HOME/db/DB/$db_name" || { echo "Failed to navigate to table."; exit 1; }



while true; do
  read -p "Enter table name: " tableName

  if [[ ! -f "$tableName" ]]; then
    echo "Table '$tableName' does not exist. please enter Another name ."
  else
    if [[ ! -f "$tableName.tp" ]]; then
      echo "Data type file '$tableName.tp' does not exist."
    else
      break  
    fi
  fi
done

IFS=: read -r -a columns < "$tableName"
IFS=: read -r -a columnTypes < "$tableName.tp"


if [[ ${#columns[@]} -ne ${#columnTypes[@]} ]]; then
  echo "Number of columns in the table file does not match the number of data types in the data type file."
  exit 1
fi
for ((i=0; i<${#columns[@]}; i++)); do
  colName="${columns[$i]}"
  colType="${columnTypes[$i]}"
  case $colType in
    int|string)
      ;;
    *)
      echo "Unknown data type '$colType' for column '$colName'."
      exit 1
      ;;
  esac
done


dataIndex=0


declare -A columnValueMap
for ((i=0; i<${#columns[@]}; i++)); do
  colName="${columns[$i]}"
  colType="${columnTypes[$i]}"


  while true; do
    read -p "Enter $colName ($colType): " value

    case $colType in
      int)
        [[ "$value" =~ ^[0-9]+$ ]] || { echo "Invalid input. Enter a valid integer."; continue; }
        ;;
      string)

        [[ "$value" =~ ^[a-zA-Z]+$ ]] || { echo "Invalid input. String cannot contain commas or spaces."; continue; }

        ;;
      *)
        echo "Unknown data type: $colType"
        exit 1
        ;;
    esac


    if [[ $colName == "${columns[0]}" ]]; then 
      grep -q "^$value:" "$tableName" && { echo "Error: Primary key value '$value' already exists."; continue; }
    fi

    columnValueMap[$colName]="$value"
    break
  done


  if [[ $((i + 1)) -eq ${#columns[@]} ]]; then
    dataString="${columnValueMap[$colName]}"
  else
    dataString="${columnValueMap[$colName]}:"
  fi
  dataToInsert+=("$dataString")
done


#if [[ ${#dataToInsert[@]} -ne ${#columns[@]} ]]; then/echo ${#dataToInsert[@]} ${#columns[@]}
#  echo "Number of provided data values does not match the number of columns."
#  exit 1
#fi


for ((i=0; i<${#dataToInsert[@]}; i++)); do
  echo -n "${dataToInsert[$i]}" >> "$tableName"
done
dataToInsert=()
echo  >> "$HOME/db/DB/$db_name/$tableName"

echo "Data inserted successfully into '$tableName'"


