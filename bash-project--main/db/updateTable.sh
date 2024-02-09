#!/bin/bash

cd "$HOME/db/DB/$db_name" || { echo "Failed to navigate to table."; exit 1; }

while true; do
    read -p "Enter table name: " tableName
    if [[ ! -f "$tableName" ]]; then
        echo "Table '$tableName' does not exist."
    else 
        break
    fi
done

if [[ ! -f "$tableName.tp" ]]; then
    echo "Error: Data type file '$tableName.tp' does not exist."
fi

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
            echo "Error: Unknown data type '$colType' for column '$colName'."
            exit 1
            ;;
    esac
done

declare -A columnValueMap

read -p "Enter primary key value: " primaryKeyValue

found=false
for ((i=0; i<${#columns[@]}; i++)); do
    colName="${columns[$i]}"
    colType="${columnTypes[$i]}"
  
    if [[ "$colName" == "${columns[0]}" ]]; then
        if grep -q "^$primaryKeyValue:" "$tableName"; then 
            found=true
            break
        else
            echo "Primary key value '$primaryKeyValue' does not exist."
        fi
    fi
done

if [[ "$found" == true ]]; then
    for ((i=1; i<${#columns[@]}; i++)); do
        colName="${columns[$i]}"
        colType="${columnTypes[$i]}"
  
        while true; do
            read -p "Enter new value for $colName ($colType): " value
      
            case $colType in
                int)
                    [[ "$value" =~ ^[0-9]+$ ]] || { echo "Invalid input. Enter a valid integer."; continue; }
                    ;;
                string)
                    [[ "$value" =~ ^[a-zA-Z]+$ ]] || { echo "Invalid input. Enter a valid string."; continue; }
                    ;;
                *)
                    echo "Unknown data type: $colType"
                    exit 1
                    ;;
            esac
      
            columnValueMap[$colName]="$value"
            break
        done
    done
  
    oldData=$(grep "^$primaryKeyValue:" "$tableName")
    newData="$primaryKeyValue"
  
    for ((i=1; i<${#columns[@]}; i++)); do
        colName="${columns[$i]}"
        if [[ "$colName" == "${columns[0]}" ]]; then
            newData+="${columnValueMap[$colName]}:"
        else
            newData+=":${columnValueMap[$colName]}"
        fi
    done
  
    sed -i "s|$oldData|$newData|" "$tableName"
  
    echo "Data updated successfully in '$tableName'"
fi

