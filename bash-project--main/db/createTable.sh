#!/bin/bash

cd "$HOME/db/DB/$db_name" || { echo "Failed to navigate to database directory."; exit 1; }

validate_table_name() {

    local name="$1"
    local max_length=30
    local reserved_words=("SELECT" "UPDATE" "CREATE" "DELETE" "INSERT" "FROM" "WHERE" "AND" "OR" "JOIN")
    if [[ ${#name} -ge 3 && ${#name} -le $max_length &&
          "${name:0:1}" =~ [a-zA-Z] &&
          "$name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ &&
          "$(echo "$name" | tr '[:upper:]' '[:lower:]')" == "$name" &&
          ! " ${reserved_words[@]} " =~ " ${name^^} " &&
          ! "$name" =~ " " ]]; then
        return 0
    else
        echo "Invalid table name. Please follow the naming rules."
        return 1
    fi
}

validate_column_name() {
    local name="$1"
    local max_length=30
    if [[ ${#name} -ge 2 && ${#name} -le $max_length &&
          "${name:0:1}" =~ [a-zA-Z] &&
          "$name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ &&
          ! "$name" =~ " " ]]; then
        return 0
    else
        echo "Invalid column name. Please follow the naming rules."
        return 1
    fi
}


while true; do

    read -p "Enter Table Name: " tbname

    if validate_table_name "$tbname"; then
        if [[ -f "$tbname" ]]; then
            echo "Table '$tbname' already exists. please enter new name"
            
        else
            break
        fi
    fi
done

touch "$tbname" || { echo "Failed to create table file."; exit 1; }
touch "$tbname.tp" || { echo "Failed to create table data type file."; exit 1; }

read -p "Enter primary key name: " pk_name
while ! validate_column_name "$pk_name"; do
    echo "Invalid primary key name. Please enter a valid name."
    read -p "Enter primary key name: " pk_name
done

read -p "Enter primary key datatype: [string/int] " pk_dtype
while [[ "$pk_dtype" != "int" && "$pk_dtype" != "string" || -z "$pk_dtype" ]]; do
    echo "Invalid primary key datatype."
    read -p "Enter primary key datatype: [string/int] " pk_dtype
done

echo -n "$pk_name" >> "$tbname"
echo -n "$pk_dtype" >> "$tbname.tp"

column_counter=1

read -p "Enter No of columns (excluding primary key): " n

if [[ $n =~ ^[1-9]*$ ]]; then
    for ((i = 1; i <= $n; i++)); do
        while true; do
            read -p "Enter column $((i + column_counter)) name: " name

            if ! validate_column_name "$name"; then
                echo "Invalid column name. Please enter a valid name."
                continue
            fi


             if grep -q "$name" "$tbname"; then
                echo "Column '$name' already exists. Please enter a new column name."
                continue
            else
                break
            fi

            break
        done

        read -p "Enter column datatype: [string/int] " dtype
        while [[ "$dtype" != "int" && "$dtype" != "string" || -z "$dtype" ]]; do
            echo "Invalid datatype"
            read -p "Enter column datatype: [string/int] " dtype
        done

        if [[ $((i + column_counter)) -eq $((n + column_counter)) ]]; then
            echo -n ":$dtype" >> "$tbname.tp"
        else
            echo -n ":$dtype" >> "$tbname.tp"
        fi

        if [[ $((i + column_counter)) -eq $((n + column_counter)) ]]; then
            echo -n ":$name" >> "$tbname"
             
        else
            echo -n ":$name" >> "$tbname"
            
        fi
    done

    echo "$tbname has been created successfully."
    echo >> "$tbname"
  
else
    echo "Invalid input. Number of columns must be a non-negative integer."
    exit 1
fi

