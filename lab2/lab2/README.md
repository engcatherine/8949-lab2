# Backup and Restore Project

## Overview
This project automatically backs up a directory, keeps limited copies, and allows restoring old versions.

## Files
- `backupd.sh` → makes periodic backups  
- `restore.sh` → restores old or new versions  
- `Makefile` → runs the backup easily  

## How to Run
1. Put your files inside `myfiles/`
2. Run the backup:
   ```bash
   make

