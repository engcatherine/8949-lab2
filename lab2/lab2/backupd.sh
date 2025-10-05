#!/bin/bash
# Usage: backupd.sh dir backupdir interval-secs max-backups

dir=$1
backupdir=$2
interval=$3
max=$4

mkdir -p "$backupdir"
ls -lR "$dir" > directory-info.last

while true
do
    sleep $interval
    ls -lR "$dir" > directory-info.new

    if ! diff directory-info.last directory-info.new > /dev/null
    then
        timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
        cp -r "$dir" "$backupdir/$timestamp"
        echo "Backup created at $timestamp"

        cd "$backupdir"
        total=$(ls -1 | wc -l)
        if [ $total -gt $max ]; then
            old=$(ls -1t | tail -n +$(($max+1)))
            rm -rf $old
        fi
        cd -

        cp directory-info.new directory-info.last
    fi
done
