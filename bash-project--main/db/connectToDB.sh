#!/bin/bash

check_db_directory() {

    if [ ! -d "DB" ]; then
        echo "'DB' directory not found."
        
    fi
}
list_databases() {

    echo "Available databases:"
    if [ -d "DB/$db_name" ]; then
       
         ls "DB/$db_name"| awk '{print NR, $1}'
    else
        echo "Not found in database $db_name."
    fi
}
list_tables() {
    db_directory="DB/$db_name"  
    if [ -d "$db_directory" ]; then
        echo "Available tables in tables : $db_name "
        ls "$db_directory" | grep -v ".tp" | awk '{print NR, $1}'
    else
        echo "No tables found in database $db_name"
    fi
}
prompt_for_database() {
    read -p "Enter the name of the database you want to connect: " db_name
}

check_database_existence() {
    if [ ! -d "DB/$db_name" ]; then
        echo "Database '$db_name' does not exist. Return to the main menu "
        source menu.sh
    fi
}


display_menu() {
    echo "----------------"
    echo "1. Create table"
    echo "2. List tables"
    echo "3. Drop table"
    echo "4. Insert into table"
    echo "5. Select from table"
    echo "6. Delete from table"
    echo "7. Update table"
    echo "8. Exit"
    echo "----------------"
}

execute_user_choice() {
    case $choice in
        1) source createTable.sh ;;
        2) source list_tables.sh;;
        3) source dropTable.sh ;;
        4) source insertTable.sh ;;
        5) source selectTable.sh ;;
        6) source deleteFromTable.sh ;;
        7) source updateTable.sh ;;
        8) source menu.sh ;;
        *) echo "Invalid input, please enter your choice again form 1 - 8" ;;
    esac
}

check_db_directory
list_databases
prompt_for_database
check_database_existence || exit 1

while true; do
display_menu
cd "$HOME/db"
read -p "Enter the number of your choice: " choice
execute_user_choice
done
