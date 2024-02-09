#!/bin/bash

echo "Enter table name to delete from: "
read -r dtable
if [[ -f "DB/$db_name/$dtable" ]]; then

    primary_key_column=$(awk -F ":" 'NR==1 {print $1}' "DB/$db_name/$dtable")

    if [[ -z $primary_key_column ]]; then
        echo "Primary key column not found."

    else
         
        read -p "Enter Primary Key Value: " primary_key_value

        if ! grep -q "^$primary_key_value:" "DB/$db_name/$dtable"; then
            echo "Primary key value '$primary_key_value' does not exist."
            break
        fi
        sed -i "/^$primary_key_value:/d" "DB/$db_name/$dtable"
        echo "Record with Primary key Deleted Successfully ."
       
    fi
else
    echo "Table '$dtable' does not exist."
fi
