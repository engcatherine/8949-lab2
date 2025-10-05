BACKUP_DIR=backups
SOURCE_DIR=myfiles
INTERVAL=5
MAX_BACKUPS=3

all: prepare run

prepare:
	mkdir -p $(BACKUP_DIR)

run:
	bash backupd.sh $(SOURCE_DIR) $(BACKUP_DIR) $(INTERVAL) $(MAX_BACKUPS)


