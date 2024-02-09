#!/bin/bash

while true; do
  echo "----------------"
  echo "1. Create table"
  echo "2. List tables"
  echo "3. Drop table"
  echo "4. Rename table"
  echo "5. Select from table"
  echo "6. Delete from table"
  echo "7. Update table"
  echo "8. Exit"
  echo "----------------"
  echo -n "Enter the number of your choice: "
  read -r choice

  case $choice in
    1) 
      . "createTable.sh"
      ;;
    2) 
      echo "Available tables:"
      cd DB
            ls | awk '{print NR, $1}'
 
            cd ..
             
            ;; 
      ;;
    3) 
      . "dropTable.sh"
      ;;
    4) 
      . "renameTable.sh"
      ;;
    5) 
      . "selectFromTable.sh"
      ;;
    6) 
      . "deleteFromTable.sh"
      ;;
    7) 
      . "updateTable.sh"
      ;;
    8) 
      echo "Exiting the DBMS. Goodbye!"
      break
      ;;
    *) 
      echo "Invalid input. Please enter a number between 1 and 8."
      ;;
  esac
done

