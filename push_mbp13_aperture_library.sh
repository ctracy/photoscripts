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

# notes:
#  --delete doesn't work correctly if you use shell expansion (dir/*) need to refer to just directory
#  due to sudo, root's public key is used not the user running the script

sudo $RSYNC -a --no-o --no-g -i -x -h -S --log-file=push-mbp13-aperture-library.log --delete /Users/Shared/"Master Aperture 3 Library.aplibrary" Shannon@mbp13-wifi.tracy.lan:/Users/Shared

