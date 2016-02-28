#!/bin/sh

# use built-in rsync (OS X 10.4 and later):
RSYNC="/usr/bin/rsync -E"

# sudo runs the backup as root
# --eahfs enables HFS+ mode
# -a turns on archive mode (recursive copy + retain attributes)
# -x don't cross device boundaries (ignore mounted volumes)
# -S handle sparse files efficiently
# --showtogo shows the number of files left to process
# --delete deletes any files that have been deleted locally
# $* expands to any extra command line options you may give

#sudo $RSYNC -i -a -x -h -S --log-file=backup.log --delete \
#  --progress --stats --exclude-from backup_excludes.txt $* / /Volumes/mbp15-backup

sudo $RSYNC -a -v -x -h -S --delete /Volumes/Time\ Machine\ Backups/Backups.backupdb/mbp13/Latest/Macintosh\ HD/Users/Shared/Pictures/* Pictures/

sudo chmod -R -N Pictures/*
sudo xattr -c -r Pictures/*

sudo $RSYNC -a -v -x -h -S --delete /Volumes/Time\ Machine\ Backups/Backups.backupdb/mbp13/Latest/Macintosh\ HD/Users/Shared/Movies/* Movies/

sudo chmod -R -N Movies/*
sudo xattr -c -r Movies/*

