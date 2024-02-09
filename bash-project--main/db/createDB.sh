#!/bin/bash

while true; do
    echo "Enter the name of the database you want to create:"
    read db_name

validate_dbname() {
    if [[ ! (
        ${#db_name} -ge 3 && ${#db_name} -le 63 &&
        "${db_name:0:1}" =~ [a-zA-Z] &&
        "$db_name" =~ ^[a-zA-Z][a-zA-Z0-9]*$ &&
        "$(echo "$db_name" | tr '[:upper:]' '[:lower:]')" == "$db_name" &&
        ! ("${db_name:0:1}" == "_" && "$db_name" =~ ^system) &&
        ! "$db_name" =~ "[[:space:]]"  
    ) ]]; then
        echo "Invalid database name. Please follow the naming rules."
        return 1
    fi
}


    if validate_dbname; then

        if [[ -d "./DB/$db_name" ]]; then
            echo "Database '$db_name' already exists. Please choose a different name."
        else
            mkdir -p "./DB/$db_name"

            if [[ $? -eq 0 ]]; then
                echo "Database '$db_name' created successfully."

                source menu.sh
                break  
            else
                echo "Failed to create database '$db_name'. Check permissions or directory existence."
            fi
        fi
    else
        echo "Invalid input. Database name must be a string containing only letters."
    fi
done

