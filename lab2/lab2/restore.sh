#!/bin/bash
# Usage: restore.sh dir backupdir

dir=$1
backupdir=$2

backups=($(ls -1t "$backupdir"))
index=0

while true
do
    echo "Choose:"
    echo "1 - Restore previous version"
    echo "2 - Restore next version"
    echo "3 - Exit"
    read choice

    case $choice in
        1)
            if [ $index -lt $((${#backups[@]} - 1)) ]; then
                index=$((index + 1))
                cp -r "$backupdir/${backups[$index]}"/* "$dir/"
                echo "Restored to a previous version: ${backups[$index]}"
            else
                echo "No older backup available to restore."
            fi
            ;;
        2)
            if [ $index -gt 0 ]; then
                index=$((index - 1))
                cp -r "$backupdir/${backups[$index]}"/* "$dir/"
                echo "Restored to a next version: ${backups[$index]}"
            else
                echo "No newer backup available to restore."
            fi
            ;;
        3)
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
