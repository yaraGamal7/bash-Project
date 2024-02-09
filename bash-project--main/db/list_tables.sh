#!bin/bash
list_tables() {
    db_directory="DB/$db_name"  

    if [ -d "$db_directory" ]; then
        echo "Available tables in tables : '$db_name':"


        find "$db_directory" -type f -name "*.tp" | sed 's/.*\/\(.*\).tp/\1/'
    else
        echo "No tables found in database '$1'."
    fi
}
list_tables 

