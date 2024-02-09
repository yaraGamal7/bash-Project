#!/bin/bash

read -p "Enter the name of the table to delete: " dbtable

while [[ -z $dbtable ]]; do
  read -p "Please enter a valid table name: " dbtable
done

if [[ ! -f "DB/$db_name/$dbtable" ]]; then
  printf "\e[41mError: Table '$dbtable' doesn't exist.\e[0m\n"
  echo "Press any key to continue..."
  read
else
  read -r -p "Are you sure you want to delete $dbtable table? [y/n] " confirm
  case $confirm in
    [yY]*)
     rm "DB/$db_name/$dbtable" "DB/$db_name/$dbtable.tp"
      printf "\e[42mTable '$dbtable' deleted successfully.\e[0m\n"
      ;;
    [nN]*)
      echo "Canceled deletion"
      ;;
    *)
      echo "Invalid input (only y or n are allowed)"
      ;;
  esac
fi
