#!/bin/bash
# Usage: restore.sh dir backupdir
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: restore.sh dir backupdir"
  exit 1
fi

dir="$1"
backupdir="$2"

if [ ! -d "$dir" ]; then
  echo "Source directory '$dir' does not exist."
  exit 1
fi
if [ ! -d "$backupdir" ]; then
  echo "Backup directory '$backupdir' does not exist or has no backups."
  exit 1
fi

# backups array newest-first
backups=( $(ls -1t "$backupdir") )
if [ ${#backups[@]} -eq 0 ]; then
  echo "No backups found in $backupdir"
  exit 1
fi

index=0  # 0 == most recent

restore_index() {
  local idx="$1"
  local stamp="${backups[$idx]}"
  local src="$backupdir/$stamp"
  if [ ! -d "$src" ]; then
    echo "Backup directory missing: $src"
    return 1
  fi
  # delete current contents inside $dir but keep the dir itself
  find "$dir" -mindepth 1 -delete
  # copy all backup content (including hidden)
  cp -a "$src/." "$dir/"
  echo "$stamp"
  return 0
}

while true; do
  echo ""
  echo "Choose:"
  echo "1 - Restore the source directory to the most recent version prior to the current backup."
  echo "2 - Move forward, restoring the source directory to the next available version following the current backup."
  echo "3 - Exit"
  read -rp "Enter option (1/2/3): " choice

  case "$choice" in
    1)
      if [ "$index" -lt $(( ${#backups[@]} - 1 )) ]; then
        index=$((index + 1))
        stamp=$(restore_index "$index")
        echo "Restored to a previous version : $stamp"
      else
        echo "No older backup available to restore."
      fi
      ;;
    2)
      if [ "$index" -gt 0 ]; then
        index=$((index - 1))
        stamp=$(restore_index "$index")
        echo "Restored to a next version : $stamp"
      else
        echo "No newer backup available to restore."
      fi
      ;;
    3)
      echo "Exiting restore."
      break
      ;;
    *)
      echo "Invalid option."
      ;;
  esac
done
