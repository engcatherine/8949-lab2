#!/bin/bash
# Usage: backupd.sh dir backupdir interval-secs max-backups
set -euo pipefail

if [ "$#" -ne 4 ]; then
  echo "Usage: backupd.sh dir backupdir interval-secs max-backups"
  exit 1
fi

dir="$1"
backupdir="$2"
interval="$3"
max="$4"

if [ ! -d "$dir" ]; then
  echo "Source directory '$dir' does not exist."
  exit 1
fi
mkdir -p "$backupdir"

# initial snapshot
ls -lR "$dir" > directory-info.last

echo "Starting backup watcher: src='$dir' dest='$backupdir' interval=${interval}s max=${max}"

while true; do
  sleep "$interval"
  ls -lR "$dir" > directory-info.new

  if ! diff -q directory-info.last directory-info.new > /dev/null 2>&1; then
    timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
    target="$backupdir/$timestamp"
    mkdir -p "$target"
    cp -a "$dir/." "$target/"

    echo "Backup created at $timestamp -> $target"

    # prune old backups: keep only $max newest
    cd "$backupdir"
    total=$(ls -1 | wc -l)
    if [ "$total" -gt "$max" ]; then
      to_delete=$(ls -1t | tail -n +$(($max + 1)))
      for d in $to_delete; do
        echo "Removing old backup: $d"
        rm -rf -- "$d"
      done
    fi
    cd - > /dev/null

    mv directory-info.new directory-info.last
  else
    rm -f directory-info.new
  fi
done
