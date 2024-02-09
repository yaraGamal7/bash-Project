#!/bin/bash

if [ ! -d "$HOME/db" ]; then
    echo -e "\033[0;31mError: Your Path is\033[0m"
    pwd
    echo -e "\033[0;31mThe database directory was not found in the correct path.\033[0m"
    echo -e "\033[0;31mMake sure the 'db' directory exists in your HOME directory.\033[0m"
    exit 1
fi

while true; do
    echo
    echo "Welcome to DBMS"
    echo "--------------------"
    echo "1. Create database"
    echo "2. List databases"
    echo "3. Connect to a database"
    echo "4. Drop a database"
    echo "5. Exit"
    echo "--------------------"

    echo -n "Enter the number of your choice: "
    read -r choice

    case $choice in
        1) 
            . createDB.sh ;;
        2) 
            echo "Available databases:"
            ls -1 "DB" | awk '{print NR, $1}'
            ;;
        3) 
        	unset db_name 
            . connectToDB.sh ;;
        4) 
            read -p "Enter the name of the database to drop: " dbName
            if [[ -d "DB/$dbName" ]]; then
                read -r -p "Are you sure you want to drop the database $dbName? [y/n] " confirmDrop
                if [[ $confirmDrop =~ ^[yY]$ ]]; then
                    rm -r "DB/$dbName"
                    echo "$dbName dropped successfully."
                else
                    echo "Canceled dropping database."
                fi
            else
                echo "Invalid database name."
            fi ;;
       
        5) 
            exit ;;
        *)
            echo "Invalid input, please enter a number between 1 and 5." ;;
    esac
done


