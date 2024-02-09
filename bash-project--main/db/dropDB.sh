#!/bin/bash

while [[ -z $dbName ]]; do
    read -p "Enter the name of the database you want to delete: " dbName
done

if ! [[ -d "DB/$dbName" ]]; then
    printf "\e[41mThis database doesn't exist\e[0m\n"
else
    read -r -p "Are you sure you want to delete $dbName database? [y/n] " confirm

    case $confirm in
        [yY]*)
            rm -r "DB/$dbName"
            printf "\e[42mDatabase deleted\e[0m\n"
            ;;
        [nN]*)
            echo "Canceled deletion"
            ;;
        *)
            echo "Invalid input (only y or n are allowed)"
            ;;
    esac
fi
