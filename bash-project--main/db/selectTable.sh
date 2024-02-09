#!/bin/bash

read -p "Enter table Name: " dtable

if [[ -f DB/$db_name/$dtable ]]; then
    select choice in "select all" "select column" "select specific record using primary key" "select specific record" "exit"; do
        case $choice in
            "select all")
                echo "-------------------------"
                echo "         $dtable         "
                echo "-------------------------"
                column -t -s: DB/$db_name/$dtable
                ;;
            "select column")
                read -p "Enter Condition Column name:" field
                fid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' DB/$db_name/$dtable)
                if [[ $fid == "" ]]; then
                    echo "Column Not Found"
                    continue
                else
                    echo "-------------------------"
                    echo "         $dtable         "
                    echo "-------------------------"
                    cut -d: -f$fid DB/$db_name/$dtable
                fi
                ;;
            "select specific record using primary key")
                read -p "Enter primary key value: " pk_value
                if [[ $(awk -F: '{print $1}' DB/$db_name/$dtable | grep -x "$pk_value") ]]; then
                    echo "-------------------------"
                    echo "         $dtable         "
                    echo "-------------------------"
                    awk -F: -v pk="$pk_value" '$1 == pk' DB/$db_name/$dtable
                else
                    echo "Primary key value not found."
                fi
                ;;
            "select specific record")
                read -p "Enter Condition Column name:" field
                fid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' DB/$db_name/$dtable)
                if [[ $fid == "" ]]; then
                    echo "Column Not Found"
                    continue
                else
                    echo -e "Enter Condition Value: \c"
                    read val
                    res=$(awk 'BEGIN{FS=":"}{if ($'$fid'=="'$val'") print $'$fid'}' DB/$db_name/$dtable 2>>./.error.log)
                    if [[ $res == "" ]]; then
                        echo "Value Not Found"
                        continue
                    else
                        echo "-------------------------"
                        echo "         $dtable         "
                        echo "-------------------------"
                        awk 'BEGIN{FS=":"}{if ($'$fid'=="'$val'" || NR==1) print $0 }' DB/$db_name/$dtable
                    fi
                fi
                ;;
            "exit") 
                break 2
                ;;
            *) echo "Invalid input"
                ;;
        esac
    done
else
    echo "$dtable doesn't exist"
fi

